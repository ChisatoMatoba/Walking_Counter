class AddMessagesToSlackThreads < ActiveRecord::Migration[7.1]
  def change
    add_column :slack_threads, :messages, :text
  end
end
