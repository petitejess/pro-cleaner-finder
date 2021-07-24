class Profile < ApplicationRecord
  belongs_to :user

  has_one :documentation, :property
  has_many :images, as: imageable
end
