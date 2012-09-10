class User < ActiveRecord::Base

  has_many :user_evaluations
  has_many :updated_birds, :class_name => "Bird", :foreign_key => "updated_by_id", :order => "name ASC"
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  
  def is_admin?
    ["ckelty@ucla.edu","apanofsky@ucla.edu"].include?(email)
  end
end
