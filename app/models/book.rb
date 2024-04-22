class Book < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  # validates :book_name, presence: true
  has_many_attached :book_images
  has_one_attached :pdf_file 
  has_many :cart_items, dependent: :destroy
 
  validates :book_name, :pdf_file, :author_name, :price, :book_images, presence: true

  validate :check_for_nil_fields
  validate :pdf_file_format

  enum category: {
    fiction: 'Fiction', nonfiction: 'Nonfiction', action_adventure: 'Action/Adventure', history: 'History',biography: 'Biography', cooking: 'Cooking',comics: 'Comics',diary: 'Diary', dictionary: 'Dictionary',
    crime: 'Crime', encyclopedia: 'Encyclopedia', drama: 'Drama', health_fitness: 'Health/Fitness', fantasy: 'Fantasy', philosophy: 'Philosophy', poetry: 'Poetry',
    sports: 'Sports'
  }
  
  def check_for_nil_fields
    errors.add(:base, "One or more fields cannot be empty") if [book_name, author_name, price].any?(&:nil?)
  end
  
  def pdf_file_format
    if pdf_file.attached? && !pdf_file.content_type.in?(%w(application/pdf))
      errors.add(:pdf_file, "must be a PDF file")
    end
  end

end