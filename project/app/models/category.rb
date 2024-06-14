class Category < ApplicationRecord
  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true
  has_many :groups, dependent: :destroy
end
