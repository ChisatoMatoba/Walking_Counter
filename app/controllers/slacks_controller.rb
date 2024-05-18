class SlacksController < ApplicationController
  def index
    @slack_threads = SlackThread.all
  end

  def create
    if params[:slack_thread_url].present?
      thread_params = SlackThread.format_thread_info_from_url(params[:slack_thread_url])
      if thread_params
        # thread_paramsで指定されたスレッドを取得
        client = Slack::Web::Client.new
        response = client.conversations_replies(
          token: ENV['SLACK_SCOPE_TOKEN'],
          channel: thread_params[:channel_id],
          ts: thread_params[:thread_ts]
        )

        if response.ok
          # responseが取得できた場合、SlackThreadを保存
          @slack_thread = SlackThread.new(thread_params)

          if @slack_thread.save
            # 各メッセージを取得し、SlackPostを保存
            response.messages.each do |message|
              @slack_thread.slack_posts.create(content: message.text, author_name: message.user)
            end
            # 保存が成功したら、showページにリダイレクト
            redirect_to slack_path(@slack_thread), notice: 'スレッドが正常に取得できました！'
          else
            redirect_to slacks_path, alert: 'スレッドの取得に失敗しました'
          end
        else
          redirect_to slacks_path, alert: 'スレッドの取得に失敗しました'
        end
      end
    else
      flash[:alert] = "URLの形式が正しくありません。正しい形式：https://xxxxx.slack.com/archives/CCCCCCCCCCC/p1111111111"
      redirect_to slacks_path
    end
  end

  def show
    @slack_thread = SlackThread.find(params[:id])
  end


  private

  def slack_thread_params
    params.require(:slack_thread).permit(:channel_id, :thread_ts)
  end

  # def fetch_thread_from_url(params)
  #   url = params[:thread_url]
  #   matches = url.match(/archives\/(?<channel_id>C\w+)\/p(?<timestamp>\d+)/)
  #   puts "matches: #{matches[:channel_id]}, #{matches[:timestamp]}"
  #   if matches
  #     formatted_timestamp = matches[:timestamp].insert(10, '.')
  #     puts "matches: #{matches[:channel_id]}, #{formatted_timestamp}"
  #     client = Slack::Web::Client.new
  #     @messages = client.conversations_replies(
  #       token: ENV['SLACK_SCOPE_TOKEN'],
  #       channel: matches[:channel_id],
  #       ts: formatted_timestamp
  #     ).messages
  #   else
  #     flash[:alert] = "URLの形式が正しくありません"
  #     redirect_to slacks_path
  #   end
  # end
end
