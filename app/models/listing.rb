class Listing < ApplicationRecord
  belongs_to :profile
  has_one_attached :image

  # Validation
  validates :title, :description, :rate_per_hour, presence: true
  validates :rate_per_hour, numericality: { greater_than: 0 }
end
