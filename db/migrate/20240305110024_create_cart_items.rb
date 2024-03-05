class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.decimal :subtotal
      t.decimal :total

      t.timestamps
    end
  end
end
