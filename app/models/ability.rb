# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    if user.seller? 
      can :manage, Book, user_id: user.id 
    else 
      can :read, Book 
    end
  end 
end
