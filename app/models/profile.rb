class Profile < ApplicationRecord
  belongs_to :user

  has_one :documentation, :property
  has_many :images, as: imageable

  # Validation
  validates :first_name, :last_name, :phone, presence: true
  validates :phone, numericality: true, length: { minimum: 8 }
end
