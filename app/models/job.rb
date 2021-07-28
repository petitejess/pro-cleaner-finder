class Job < ApplicationRecord
  belongs_to :quote
  has_one :payment

  # Validation
  validates :date, :service_hour, :total_cost, presence: true
end
