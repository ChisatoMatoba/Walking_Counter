class SlackController < ApplicationController
  def fetch_thread
    client = Slack::Web::Client.new
    @messages = client.conversations_replies(
      channel: params[:channel_id],
      ts: params[:thread_ts]
    ).messages
  end
end
