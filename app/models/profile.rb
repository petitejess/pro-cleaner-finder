class Profile < ApplicationRecord
  belongs_to :user
  has_one :documentation
  accepts_nested_attributes_for :documentation
  has_one :property
  accepts_nested_attributes_for :property
  has_one_attached :image

  # Validation
  validates :first_name, :last_name, :phone, presence: true
  validates :phone, numericality: true, length: { minimum: 8 }
end
