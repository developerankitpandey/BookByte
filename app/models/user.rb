class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    enum role: { buyer: 0, seller: 1}
        
    has_many :books, dependent: :destroy

    # after_initialize :set_default_role, if: :new_record?
    # before_validation :set_default_role_before_validation, on: :create

    before_create :set_default_role

    # private 

    def set_default_role 
      self.role = :buyer
    end 
  
    def become_seller!
      update(role: :seller)
    end 
end
