class Listing < ApplicationRecord
  belongs_to :profile
  has_many :service_areas, inverse_of: :listing, autosave: true, :dependent => :destroy
  has_many :suburbs, through: :service_areas
  accepts_nested_attributes_for :service_areas, reject_if: :all_blank, allow_destroy: true
  has_one_attached :image

  # Validation
  validates :title, :description, :rate_per_hour, presence: true
  validates :rate_per_hour, numericality: { greater_than: 0 }
end
