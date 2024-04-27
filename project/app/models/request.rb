class Request < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :description, presence: true, length: { maximum: 200}
end
