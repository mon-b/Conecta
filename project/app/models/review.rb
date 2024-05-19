class Review < ApplicationRecord
  validates :activity_id, presence: true
  validates :rating, presence: true
  validates :body, presence: true, allow_blank: false
  belongs_to :activity
  belongs_to :user
end
