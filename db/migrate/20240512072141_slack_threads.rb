class SlackThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :slack_threads do |t|
      t.string :thread_id
      t.string :title
      t.datetime :started_at

      t.timestamps
    end
  end
end
