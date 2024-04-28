class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 16 }, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :birth_date, presence: true

  has_and_belongs_to_many :groups
  has_one_attached :profile_picture do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end


end
