class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :item
  validates :user_id, presence: true
  validates :item_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
