class Postcode < ApplicationRecord
  # Postcode has a many-to-one relationship with State. Postcode must belong to exactly one State, and State may have 1 or many Postcodes.
  belongs_to :state

  # Postcode has a one-to-many relationship with Suburb. Postcode may have 1 or many Suburbs, and Suburb must belong to exactly 1 Postcode.
  has_many :suburbs

  # Validation
  validates :number, presence: true, uniqueness: true, numericality: true, length: { minimum: 3, maximum: 4 }
end
