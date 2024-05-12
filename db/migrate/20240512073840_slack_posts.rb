class SlackPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :slack_posts do |t|
      t.string :post_id
      t.string :author_name
      t.text :content
      t.datetime :posted_at
      t.references :slack_thread, foreign_key: true

      t.timestamps
    end
  end
end
