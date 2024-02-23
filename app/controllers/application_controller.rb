class ApplicationController < ActionController::Base
    helper_method :current_cart 

   def current_cart 
    @current_cart ||= Cart.new(session[:cart])
   end 
end
