class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  #Removed :registerable, :recoverable for hide "Sign up" and "Forgot Password" links on sign in page
  devise :database_authenticatable, :rememberable, :trackable, :validatable


end
