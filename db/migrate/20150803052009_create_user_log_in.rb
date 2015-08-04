class CreateUserLogIn < ActiveRecord::Migration
  def change
    create_table :user_log_ins do |t|
      t.integer :user_id
      t.timestamp :logout_time

      t.timestamps null: false
    end
  end
end
