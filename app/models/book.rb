class Book < ApplicationRecord
  belongs_to :user
  has_many_attached :book_images
end
