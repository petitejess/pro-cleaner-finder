class Suburb < ApplicationRecord
  # Suburb has a many-to-one relationship with Postcode. Suburb must belong to exactly 1 Postcode, and Postcode may have 1 or many Suburbs.
  belongs_to :postcode

  # Suburb has a one-to-many relationship with Property. Suburb may have 1 or many Properties, and Property must belong to exactly 1 Suburb.
  has_many :properties

  # Suburb has a many-to-many relationship with Listing through Service Area. Suburb must have at least 1 or many Listings through Service Area, and Listing must have at least 1 or many Suburbs.
  has_many :service_areas
  has_many :listings, through: :service_areas

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
