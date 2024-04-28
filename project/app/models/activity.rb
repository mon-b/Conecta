class Activity < ApplicationRecord
  belongs_to :group
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: /\A[a-zA-Z0-9 ]+\z/ }
  validates :location, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z0-9 ]+\z/ }
  validates :date, presence: true
  validates :description, presence: true, allow_blank: false
  validates :keywords, presence: true, length: { maximum: 15 }, format: { with: /\A[a-zA-Z]+\z/ }
  validates :cost, presence: true, numericality: { greater_than: 0 }
  validates :people, presence: true, numericality: { greater_than: 0 }

  has_many_attached :pictures do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end

  # Codigo sacado de: https://stackoverflow.com/a/23856331
  before_save :downcase_fields
  def downcase_fields
    self.location.downcase!
    self.keywords.downcase!
  end

end
