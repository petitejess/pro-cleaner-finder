class Quote < ApplicationRecord
  belongs_to :request
  has_one :job

  # Validation
  validates :date, :status, presence: true
  validates :service_hour, :total_cost, numericality: { greater_than: 0 }, on: :update
end
