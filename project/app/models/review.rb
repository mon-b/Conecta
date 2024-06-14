# Modelo de las Reseñas
class Review < ApplicationRecord
  # Validaciones de atributos de la reseña
  validates :activity_id, presence: true
  validates :rating, presence: true,
                      numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :body, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false

  # Asociacion: Una reseña pertenece a una actividad y a un usuario
  belongs_to :activity
  belongs_to :user
end
