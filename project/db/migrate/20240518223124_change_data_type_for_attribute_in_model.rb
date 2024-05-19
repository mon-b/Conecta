class ChangeDataTypeForAttributeInModel < ActiveRecord::Migration[7.0]
  def change
    change_column :activities, :cost, :integer
  end
end
