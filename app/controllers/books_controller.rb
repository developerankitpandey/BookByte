class BooksController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :check_seller_status, only: [:new, :create]

    def index 
     @books = Book.all 
    end  

    def show 
     @book = Book.find(params[:id])
    end 

    def new 
     @book = current_user.books.build
    end  

    def create  
     @book = current_user.books.build(book_params)
      if @book.save 
        redirect_to @book, notice: 'Book was successsfully added'
      else 
        flash.now[:alert] = 'Failed to save the book'
        render :new 
      end 
    end 

  private 

  def book_params 
   params.require(:book).permit(:book_name, :author_name, :price, book_images: [] )
  end
  
  def check_seller_status 
    unless current_user.seller? 
      redirect_to books_path, alert: 'You need to become a seller to create books'
    end 
  end 
end
