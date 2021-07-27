class Property < ApplicationRecord
  belongs_to :suburb
  belongs_to :profile

  # Validation
  validates :storey, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validates :bed, :bath, numericality: { only_integer: true, greater_than: -1, less_than: 100 }
end
