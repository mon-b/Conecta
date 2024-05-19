class Review < ApplicationRecord
  validates :activity_id, presence: true
  validates :rating, presence: true, 
                      numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :body, presence: true, allow_blank: false
  belongs_to :activity
  belongs_to :user
end
