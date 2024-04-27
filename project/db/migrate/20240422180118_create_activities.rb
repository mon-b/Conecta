class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.belongs_to :group, index: true, foreign_key: true
      t.string :name
      t.string :location
      t.datetime :date
      t.string :description
      t.string :picture
      t.string :keywords
      t.decimal :cost
      t.integer :people

      t.timestamps
    end
  end
end
