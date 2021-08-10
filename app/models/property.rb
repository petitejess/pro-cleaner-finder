class Property < ApplicationRecord
  # Property has a many-to-one relationship with Suburb. Property must belong to exactly one Suburb, and Suburb may have 0 or many Properties.
  belongs_to :suburb

  # Property has a one-to-one relationship with Profile. Property must belong to exactly one Profile, and Profile has exactly 1 Property.
  belongs_to :profile

  # Property has a one-to-many relationship with Request. Property may have 0 or many Requests, and Request must belong to exactly 1 Property.
  has_many :requests

  # Validation
  validates :storey, :bed, :bath, presence: true
  validates :storey, numericality: { only_integer: true, greater_than: 0 }
  validates :bed, :bath, numericality: { only_integer: true, greater_than: -1 }
end
