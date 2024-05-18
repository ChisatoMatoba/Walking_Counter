class SlackThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :slack_threads do |t|
      t.string :channel_id
      t.string :thread_ts

      t.timestamps
    end
  end
end
