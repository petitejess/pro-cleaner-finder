class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # User has a one-to-one relationship with Profile. User has exactly 1 Profile, and Profile must belong to exactly one User.
  has_one :profile
end
