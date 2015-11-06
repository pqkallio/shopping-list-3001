class CreateFriendshipRequests < ActiveRecord::Migration
  def change
    create_table :friendship_requests do |t|
      t.integer :owner_id
      t.integer :target_id
      t.integer :status
      t.datetime :confirmed_at

      t.timestamps null: false
    end
  end
end
