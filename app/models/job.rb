class Job < ApplicationRecord
  belongs_to :quote
  has_one :payment
  has_one :review

  # Validation
  validates :date, :service_hour, :total_cost, presence: true
end
