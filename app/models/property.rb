class Property < ApplicationRecord
  belongs_to :suburb
  belongs_to :profile

  # Validation
  validates :storey, :bed, :bath, numericality: true, length: { minimum: 0, maximum: 99 }
end
