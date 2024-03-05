class BooksController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :check_seller_status, only: [:new, :create]

    def index 
     @books = Book.all 
    #  @selected_book_id = @books.first
    end  

    def search
      @books = Book.where("LOWER(book_name) LIKE ? OR LOWER(author_name) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%")
      render :index
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

    def destroy 
      @book = Book.find(params[:id])
      if current_user == @book.user 
        @book.destroy 
        redirect_to root_path, notice: " Book was successfully deleted"
      else 
        redirect_to root_path, alert: "You are not authorized to delete this book"
      end 
    end 

    def add_to_cart
      @book = Book.find(params[:id])
      current_user.cart_items.create(book: @book)
      redirect_to root_path, notice: "Book added to cart successfully"
    end
    
    def remove_from_cart 
      @cart_item = current_user.cart_items.find(params[:id])
      @cart_item.destroy
      redirect_to cart_path, notice: "Item removed from cart"
    end

    def cart
      @cart_items = current_user&.cart&.cart_items&.includes(:book)
    end
    
  
  private 

  def book_params 
   params.require(:book).permit(:book_name, :author_name, :price, :pdf_file, book_images: [] )
  end
  
  def check_seller_status 
    unless current_user.seller? 
      redirect_to books_path, alert: 'You need to become a seller to create books'
    end 
  end 
end
