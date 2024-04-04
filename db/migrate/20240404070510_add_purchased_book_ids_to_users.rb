class AddPurchasedBookIdsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :purchased_book_ids, :string, array: true, default: '{}'
  end
end