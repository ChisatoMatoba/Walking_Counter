class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :slack_post, foreign_key: true
      t.timestamps
    end
  end
end
