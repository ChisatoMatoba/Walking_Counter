class SlacksController < ApplicationController
  def index
    @slack_threads = SlackThread.all
  end

  def create
    if params[:slack_thread_url].present?
      thread_params = SlackThread.format_thread_info_from_url(params[:slack_thread_url])
      if thread_params
        # thread_paramsで指定されたスレッドを取得
        response = get_response_from_slack_api(thread_params[:channel_id], thread_params[:thread_ts])

        if response.ok
          # responseが取得できた場合、SlackThread及びposts, imagesを保存
          slack_thread_save(@slack_thread, response)
        else
          redirect_to slacks_path, alert: 'スレッドの取得に失敗しました'
        end
      end
    else
      flash[:alert] = 'URLの形式が正しくありません。正しい形式：https://xxxxx.slack.com/archives/CCCCCCCCCCC/p1111111111'
      redirect_to slacks_path
    end
  end

  def show
    @slack_thread = SlackThread.find(params[:id])
    @slack_posts = @slack_thread.slack_posts
  end

  def reload_thread
    @slack_thread = SlackThread.find(params[:id])
    response = get_response_from_slack_api(@slack_thread.channel_id, @slack_thread.thread_ts)

    if response.ok
      @slack_thread.save_posts(response.messages)
      redirect_to slack_path(@slack_thread), notice: 'スレッドが更新されました！'
    else
      redirect_to slack_path(@slack_thread), alert: 'スレッドの更新に失敗しました'
    end
  end

  def destroy
    @slack_thread = SlackThread.find(params[:id])
    @slack_thread.destroy
    redirect_to slacks_path, notice: 'スレッドを削除しました'
  end

  private

  def slack_thread_params
    params.require(:slack_thread).permit(:channel_id, :thread_ts)
  end

  def get_response_from_slack_api(channel, thread_ts)
    client = Slack::Web::Client.new
    client.conversations_replies(
      token: ENV['SLACK_SCOPE_TOKEN'],
      channel: channel,
      ts: thread_ts
    )
  end

  def slack_thread_save(new_slack_thread, response)
    new_slack_thread = SlackThread.new(new_slack_thread)

    if new_slack_thread.save
      # 各メッセージを、SlackPostに保存
      new_slack_thread.save_posts(response.messages)
      new_slack_thread.save_images
      # 保存が成功したら、showページにリダイレクト
      redirect_to slack_path(new_slack_thread), notice: 'スレッドが正常に取得できました！'
    else
      new_slack_thread slacks_path, alert: 'スレッドの取得に失敗しました'
    end
  end
end
