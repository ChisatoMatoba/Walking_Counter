class SlackPost < ApplicationRecord
  belongs_to :slack_thread
  has_many :images, dependent: :destroy

  serialize :image_urls, JSON
end
