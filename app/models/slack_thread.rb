class SlackThread < ApplicationRecord
  has_many :slack_posts, dependent: :destroy

  def self.format_thread_info_from_url(url)
    matches = url.match(/archives\/(?<channel_id>C\w+)\/p(?<timestamp>\d{16})/)
    return nil unless matches
    formatted_timestamp = "#{matches[:timestamp][0...10]}.#{matches[:timestamp][10...16]}"
    { channel_id: matches[:channel_id], thread_ts: formatted_timestamp }
  end
end
