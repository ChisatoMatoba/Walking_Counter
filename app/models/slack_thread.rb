class SlackThread < ApplicationRecord
  has_many :slack_posts, dependent: :destroy

  def save_posts(messages)
    messages.each do |message|
      unless self.slack_posts.exists?(post_id: message.ts)
        user_info = get_user_info(message.user)
        image_urls = message.files&.map { |file| file.url_private_download } if message.files&.any?

        slack_post_params = {
          post_id: message.ts,
          author_name: user_info.name,
          content: message.text,
          posted_at: Time.at(message.ts.to_f),
          image_urls: image_urls
        }
        self.slack_posts.create(slack_post_params)
      end
    end
  end

  class << self
    def format_thread_info_from_url(url)
      matches = url.match(/archives\/(?<channel_id>C\w+)\/p(?<timestamp>\d{16})/)
      return nil unless matches
      formatted_timestamp = "#{matches[:timestamp][0...10]}.#{matches[:timestamp][10...16]}"
      { channel_id: matches[:channel_id], thread_ts: formatted_timestamp }
    end
  end

  private

  def get_user_info(user_id)
    client = Slack::Web::Client.new
    response = client.users_info(
      token: ENV['SLACK_SCOPE_TOKEN'],
      user: user_id
    )
  end

  def save_images
    self.slack_posts.each do |post|
      post.image_urls&.each do |image_url|
        image = Image.new
        image.download_and_store_image(post, image_url)
      end
    end
  end
end
