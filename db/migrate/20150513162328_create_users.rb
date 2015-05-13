class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :username
      t.string :email
      t.timestamp :joined
      t.timestamp :last_signin
      t.boolean :available
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
