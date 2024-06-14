class Group < ApplicationRecord
  after_initialize :set_default_rating, if: :new_record?
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
  validates :rating, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }

  has_one_attached :profile_picture do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end

  def set_default_rating
    self.rating ||= 0.0
  end

  def calculate_average_rating
    reviews = Review.joins(:activity).where('activities.group_id = ?', id)
    average_rating = reviews.average(:rating)
    self.rating = average_rating.nil? ? 0.0 : average_rating
    save
    rating
  end

end
