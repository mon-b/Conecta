class Group < ApplicationRecord
  belongs_to :category
  #belongs_to :user
  has_and_belongs_to_many :users
  has_many :activities, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true, format: { with: /\A[a-zA-Z0-9 ]+\z/ }
  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :description, presence: true, allow_blank: false
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }

  has_one_attached :profile_picture do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end
end
