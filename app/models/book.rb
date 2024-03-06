class Book < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  # validates :book_name, presence: true
  has_many_attached :book_images
  has_one_attached :pdf_file 
  has_many :cart_items, dependent: :destroy
  validates :book_name, presence: true
end
