class Suburb < ApplicationRecord
  belongs_to :postcode

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
