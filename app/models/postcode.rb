class Postcode < ApplicationRecord
  belongs_to :state
  has_many :suburbs

  # Validation
  validates :number, presence: true, uniqueness: true, numericality: true, length: { minimum: 3, maximum: 4 }
end
