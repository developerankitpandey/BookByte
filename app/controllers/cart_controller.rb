class CartController < ApplicationController 

    def create 
        book = Book.find(params[:id])
        current_cart.add_book(book)
        render json: { message: "Book added to cart successfully" }
    end 
end 
