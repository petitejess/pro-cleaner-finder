class Quote < ApplicationRecord
  belongs_to :request
  has_one :job

  # Validation
  validates :date, :service_hour, :total_cost, :status, presence: true
end
