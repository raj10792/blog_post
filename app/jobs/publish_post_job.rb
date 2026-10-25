class PublishPostJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)

    puts "Processing Post #{post.title}"

    sleep 10

    puts "Completed"
  end
end
