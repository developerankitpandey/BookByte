class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    enum role: { buyer: 0, seller: 1}
        
    has_many :books, dependent: :destroy
    has_one :cart, dependent: :destroy

    before_create :set_default_role
    after_create :create_cart
    
    def set_default_role 
      self.role = :buyer
    end 
  
    def become_seller!
      update(role: :seller)
    end 

    private 

    def create_cart 
     Cart.create(user: self)
    end 
end
