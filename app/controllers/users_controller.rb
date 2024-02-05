class UsersController < ApplicationController

    def become_seller 
       current_user.become_seller!
       redirect_to root_path, notice: 'You are now a seller!'
    end 
end
