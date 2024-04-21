class Group < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :description, presence: true, allow_blank: false
end
