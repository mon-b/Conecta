# Modelo de las solicitudes
class Request < ApplicationRecord
  # Asociacion: Una solicitud pertenece a un usuario y a un grupo
  belongs_to :user
  belongs_to :group

  # Validaciones de atributos de la solicitud
  validates :description, presence: true, length: { maximum: 200}
end
