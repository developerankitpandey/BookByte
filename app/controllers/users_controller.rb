class UsersController < ApplicationController

    def become_seller 
       current_user.become_seller!
       redirect_to root_path, notice: 'Welcome! You can now contribute by adding books. Your contribution will be donated, making a difference.'
    end 
end
