class ApplicationController < ActionController::Base
    helper_method :current_cart 

   def current_cart 
    @current_cart ||= current_user.cart.present? ? current_user.cart : Cart.new(user_id: current_user.id)
   end 
end
