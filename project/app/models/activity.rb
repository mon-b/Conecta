# Modelo de Actividad
class Activity < ApplicationRecord
  # Relaciones
  belongs_to :group

  # Validaciones
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9. ]+\z/ }, length: { maximum: 50 }
  validates :location, presence: true, length: { maximum: 100}, format: { with: /\A[\p{L}\p{N}. ]+\z/}
  validates :date, presence: true
  validates :description, presence: true, allow_blank: false
  validates :keywords, presence: true, length: { maximum: 50 }, format: { with: /\A[\p{L}\p{N}. ]+\z/ }
  validates :cost, presence: true, numericality: { greater_than: 0 }
  validates :people, presence: true, numericality: { greater_than: 0 }

  has_many :reviews, dependent: :destroy

  # Asociacion de imagenes
  has_many_attached :pictures do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
  end

  # Codigo sacado de: https://stackoverflow.com/a/23856331
  # Se encarga de convertir las palabras clave a minusculas
  # @return [String] palabras clave de la actividad
  before_save :downcase_fields
  def downcase_fields
    self.keywords.downcase!
  end

end
