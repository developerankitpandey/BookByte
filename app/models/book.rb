class Book < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  # validates :book_name, presence: true
  has_many_attached :book_images
  has_one_attached :pdf_file 
  has_many :cart_items, dependent: :destroy
  validates :book_name, presence: true

  enum category: {
    fiction: 'Fiction', nonfiction: 'Nonfiction', action_adventure: 'Action/Adventure', history: 'History',biography: 'Biography', cooking: 'Cooking',comics: 'Comics',diary: 'Diary', dictionary: 'Dictionary',
    crime: 'Crime', encyclopedia: 'Encyclopedia', drama: 'Drama', health_fitness: 'Health/Fitness', fantasy: 'Fantasy', philosophy: 'Philosophy', poetry: 'Poetry',
    sports: 'Sports'
  }
  
end

