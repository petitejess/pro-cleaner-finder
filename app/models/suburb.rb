class Suburb < ApplicationRecord
  belongs_to :postcode
  has_many :properties
  has_many :service_areas
  has_many :listings, through: :service_areas

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
