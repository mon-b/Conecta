# Modelo de las solicitudes
class Request < ApplicationRecord
  # Relaciones
  belongs_to :user
  belongs_to :group

  # Validaciones
  validates :description, presence: true, length: { maximum: 200}
end
