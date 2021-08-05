class Listing < ApplicationRecord
  # Listing has a many-to-one relationship with Profile. Listing must belong to exactly one Profile, and Profile may have 0 or many Listings.
  belongs_to :profile

  # Listing has a many-to-many relationship with Suburb through Service Area. Listing must have at least 1 or many Suburbs, and Suburb must have at least 1 or many Listings through Service Area.
  has_many :service_areas, inverse_of: :listing, autosave: true, dependent: :destroy
  has_many :suburbs, through: :service_areas
  # Listing accepts attributes for Service Area through nested form
  accepts_nested_attributes_for :service_areas, reject_if: :all_blank, allow_destroy: true

  # Listing can have 0 or 1 image
  has_one_attached :image

  # Listing has a one-to-many relationship with Request. Listing may have 0 or many Requests, and Request must belong to exactly 1 Listing.
  has_many :requests
  
  # Validation
  validates :title, :description, :rate_per_hour, presence: true
  validates :rate_per_hour, numericality: { greater_than: 0 }
end
