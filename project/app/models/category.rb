# Modelo de las Categorias
class Category < ApplicationRecord

  # Validaciones de atributos de la categoria
  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true

  # Asociacion: Una categoria puede tener muchos grupos
  has_many :groups, dependent: :destroy
end
