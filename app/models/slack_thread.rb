class SlackThread < ApplicationRecord
  has_many :slack_posts, dependent: :destroy
end
