# Copilot instructions

## Application
- This repository is a Rails monolith. Follow the existing Rails MVC structure and conventions.
- Use the Ruby version in `.ruby-version` and the Rails/dependency versions in `Gemfile`.
- PostgreSQL is the database; make schema changes with migrations and keep `db/schema.rb` in sync.
- Front-end styles use Tailwind CSS through `tailwindcss-rails` (Tailwind CSS v4). Keep styling in utility classes and `app/assets/tailwind/application.css`; do not introduce a separate CSS framework.
- JavaScript uses import maps, Turbo, and Stimulus. Avoid adding a JavaScript bundler unless the task requires one.

## Authentication and authorization
- Authentication uses Rails' built-in authentication concern, `Current.session`, and signed session cookies. Reuse this system rather than adding another authentication library.
- Controllers are authenticated by default. Explicitly allow unauthenticated access only for actions that need it, such as sign-in, registration, and password recovery.
- Keep user-facing writes protected by authentication and use strong parameters for submitted data.
- Never store plain-text passwords or expose password digests or reset tokens.

## Changes and verification
- Add or update focused Minitest tests under `test/` for behavior changes. Use the existing integration test session helper when authentication is needed.
- Run relevant tests with `bin/rails test`; build styles with `bin/rails tailwindcss:build` when changing Tailwind inputs or classes.
- Follow the existing RuboCop conventions and run `bin/rubocop` for Ruby changes.
- Prefer small, focused changes and preserve established behavior unless the task explicitly calls for a change.
