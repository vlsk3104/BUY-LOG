class Log < ApplicationRecord
  belongs_to :item
  default_scope -> { order(created_at: :desc) }
  validates :item_id, presence: true
end
