class DeletePicsFromModels < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :profile_picture
    remove_column :activities, :picture
  end
end
