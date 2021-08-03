class State < ApplicationRecord
  # State has a one-to-many relationship with Postcode. State may have 1 or many Postcode, and Postcode must belong to exactly 1 State.
  has_many :postcodes

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
