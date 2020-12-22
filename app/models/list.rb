class List < ApplicationRecord
  belongs_to :user
  belongs_to :item
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :from_user_id, presence: true
end
