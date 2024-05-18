require 'open-uri'

class Image < ApplicationRecord
  belongs_to :slack_post
  has_one_attached :file

  def download_and_store_image(post, image_url)
    file_data = URI.open(image_url, "Authorization" => "Bearer #{ENV['SLACK_SCOPE_TOKEN']}")
    self.file.attach(io: file_data, filename: File.basename(image_url))
    self.slack_post = post
    self.save!
  rescue OpenURI::HTTPError => e
    puts "画像取得に失敗しました: #{e.message}"
  ensure
    file_data.close if file_data
  end
end
