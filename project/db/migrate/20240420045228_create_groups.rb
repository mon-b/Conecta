class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.decimal :rating
      t.string :description

      t.timestamps
    end
  end
end
