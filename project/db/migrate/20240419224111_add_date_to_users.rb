class AddDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :birth_date, :datetime
  end
end
