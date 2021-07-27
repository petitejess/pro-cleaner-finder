class Profile < ApplicationRecord
  belongs_to :user
  has_one :documentation, inverse_of: :profile, autosave: true, :dependent => :destroy
  accepts_nested_attributes_for :documentation, allow_destroy: true
  has_one :property, inverse_of: :profile, autosave: true, :dependent => :destroy
  accepts_nested_attributes_for :property, allow_destroy: true
  has_one_attached :image
  has_many :listings

  # Validation
  validates :first_name, :last_name, :phone, presence: true
  validates :phone, numericality: true, length: { minimum: 8 }
end
