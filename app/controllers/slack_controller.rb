class SlackController < ApplicationController
  def index
  end

  def fetch_thread_from_url
    url = params[:thread_url]
    matches = url.match(/archives\/(?<channel_id>C\w+)\/p(?<timestamp>\d+)/)
    puts "matches: #{matches[:channel_id]}, #{matches[:timestamp]}"
    if matches
      formatted_timestamp = matches[:timestamp].insert(10, '.')
      puts "matches: #{matches[:channel_id]}, #{formatted_timestamp}"
      client = Slack::Web::Client.new
      @messages = client.conversations_replies(
        token: ENV['SLACK_SCOPE_TOKEN'],
        channel: matches[:channel_id],
        ts: formatted_timestamp
      ).messages
      render :index
    else
      flash[:alert] = "Invalid URL format."
      redirect_to slack_index_path
    end
  end
end
