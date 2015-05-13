class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :list_id
      t.integer :product_id
      t.integer :amount
      t.timestamp :purchase_date

      t.timestamps null: false
    end
  end
end
