class BooksController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :check_seller_status, only: [:new, :create]

    def index 
      # @books = Book.paginate(page: params[:page], per_page: 15)
      if params[:category].present? && Book.categories.include?(params[:category])
        @books = Book.where(category: params[:category]).order(created_at: :desc).paginate(page: params[:page], per_page: 18)
      else
        @books = Book.order(created_at: :desc).paginate(page: params[:page], per_page: 18)
      end
    
      if @books.empty?
        flash.now[:notice] = "No books found for the selected category."
      end
    end

    def search
      if params[:category].present? && Book.categories.include?(params[:category])
        if request.referer&.include?('profile')
          @books = current_user.books.where(category: params[:category]).where("LOWER(book_name) LIKE ? OR LOWER(author_name) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%").paginate(page: params[:page], per_page: 10)
        else
          @books = Book.where(category: params[:category]).where("LOWER(book_name) LIKE ? OR LOWER(author_name) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%").paginate(page: params[:page], per_page: 10)
        end
      else
        if request.referer&.include?('profile')
          @books = current_user.books.where("LOWER(book_name) LIKE ? OR LOWER(author_name) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%").paginate(page: params[:page], per_page: 10)
        else
          @books = Book.where("LOWER(book_name) LIKE ? OR LOWER(author_name) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%").paginate(page: params[:page], per_page: 10)
        end
      end
      
      flash.now[:notice] = "No Books found" if @books.empty?
      if request.referer&.include?('profile')
        render :profile
      else
        render :index
      end
    end
    

    def show 
     @book = Book.find(params[:id])
      # if current_user.purchased_book_ids.include?(@book.id.to_s)

      # else
      #   redirect_to checkout_book_path(@book), alert: "Please complete the payment to download the book."
      # end
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
      if current_user.cart_items.exists?(book_id: @book.id)
        redirect_to root_path, alert: "You have already added this book to your cart"
      else
      current_user.cart_items.create(book: @book)
      redirect_to root_path, notice: "Book added to cart successfully"
      end
    end 
    
    def remove_from_cart 
      @cart_item = current_user.cart_items.find(params[:id])
      @cart_item.destroy
      redirect_to cart_books_path, notice: "Item removed from cart"
    end

    def cart
      @cart_items = current_user.cart_items&.includes(:book)
    end

    def checkout
      @book = Book.find(params[:id])
  
      flash.now[:notice] = "This website is in testing mode. For payment, use the following test card details:\n\nCard Number: 4242 4242 4242 4242\nExpiry Date: Any future date\nCVC: Any 3 digits"

      # Create the Stripe checkout session
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'inr',
            product_data: {
              name: @book.book_name,
            },
            unit_amount: (@book.price * 100).to_i, # Convert price to paise
          },
          quantity: 1
        }],
        mode: 'payment', # Specify the mode as 'payment'
        success_url: book_url(@book),
        cancel_url: books_url,
        metadata: {
          'book_id' => @book.id
        }
      )
      #  session = @session.payment_intent
      # if request.referrer == book_url(@book)
      #   current_user.update(purchased_book_ids: (current_user.purchased_book_ids || []) << @book.id.to_s)
      # end
    end
   
    def profile 
      if params[:category].present? && Book.categories.include?(params[:category])
        @books = current_user.books.where(category: params[:category]).order(created_at: :desc).paginate(page: params[:page], per_page: 18)
      else
        @books = current_user.books.order(created_at: :desc).paginate(page: params[:page], per_page: 18)
      end
    
      if @books.empty?
        flash.now[:notice] = "No books found"
      end
    end

  private 

  def book_params 
   params.require(:book).permit(:book_name, :author_name, :price, :category, :pdf_file, book_images: [] )
  end
  
  def check_seller_status 
    unless current_user.seller? 
      redirect_to books_path, alert: 'You need to become a seller to create books'
    end 
  end 
end
