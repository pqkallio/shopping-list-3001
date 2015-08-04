class DeleteAvailableFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :available
    add_column :users, :admin, :boolean
  end
end
