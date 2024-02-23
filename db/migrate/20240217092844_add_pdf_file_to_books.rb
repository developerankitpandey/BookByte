class AddPdfFileToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :pdf_file, :binary
  end
end
