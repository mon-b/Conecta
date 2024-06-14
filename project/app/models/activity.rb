# Modelo de Actividades
class Activity < ApplicationRecord

  # Asociacion: Una actividad pertenece a un grupo
  belongs_to :group

  # Validaciones de atributos de la actividad
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9. ]+\z/ }, length: { maximum: 50, minimum: 5 }
  validates :location, presence: true, length: { maximum: 100, minimum: 5 }, format: { with: /\A[\p{L}\p{N}. ]+\z/}
  validates :date, presence: true
  validates :description, presence: true, allow_blank: false
  validates :keywords, presence: true, length: { maximum: 50 }, format: { with: /\A[\p{L}\p{N}. ]+\z/ }
  validates :cost, presence: true, numericality: { greater_than: 0 }
  validates :people, presence: true, numericality: { greater_than: 0 }

  # Asociacion: Una actividad puede tener muchas reviews
  has_many :reviews, dependent: :destroy

  # Asociacion: Una actividad puede tener muchas imagenes
  # @return [ActiveStorage::Attached::Many] imagenes de la actividad
  has_many_attached :pictures do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end

  # Codigo sacado de: https://stackoverflow.com/a/23856331
  # Se encarga de convertir las palabras clave a minusculas antes de guardarlas
  # @return [String] palabras clave de la actividad
  before_save :downcase_fields
  def downcase_fields
    self.keywords.downcase!
  end

end
