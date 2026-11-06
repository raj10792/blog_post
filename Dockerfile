# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.5

########################################
# Base
########################################
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      postgresql-client \
      redis-tools && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle \
    LANG=C.UTF-8

########################################
# Build
########################################
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      pkg-config \
      libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf \
      ~/.bundle \
      $BUNDLE_PATH/ruby/*/cache \
      $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

COPY . .

RUN bundle exec bootsnap precompile --gemfile

RUN bundle exec bootsnap precompile app/ lib/

ENV SECRET_KEY_BASE_DUMMY=1

RUN bundle exec rails assets:precompile

########################################
# Runtime
########################################
FROM base

RUN groupadd --system --gid 1000 rails && \
    useradd rails \
      --uid 1000 \
      --gid 1000 \
      --create-home \
      --shell /bin/bash

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN chown -R rails:rails /rails

USER rails

EXPOSE 3000

HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=30s \
            --retries=3 \
CMD curl -f http://localhost:3000/up || exit 1

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]