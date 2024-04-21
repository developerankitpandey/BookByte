class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

    enum role: { buyer: 0, seller: 1}
        
    has_many :books, dependent: :destroy
    has_one :cart, dependent: :destroy
    has_many :cart_items, dependent: :destroy
    
    before_create :set_default_role
    after_create :create_cart
    
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    # validate :password_complexity

    def set_default_role 
      self.role = :buyer
    end 
  
    def become_seller!
      update(role: :seller)
    end 

    def self.from_google(u)
      create_with(uid: u[:uid], provider: 'google',
                  password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
    end

    private 

    def create_cart 
     Cart.create(user: self)
    end 

    # def password_complexity
    #   return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
  
    #   errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    # end
end
