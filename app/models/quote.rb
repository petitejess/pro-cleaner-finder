class Quote < ApplicationRecord
  # Quote has a one-to-one relationship with Request. Quote must belong to exactly one Request, and Request can have 0 or 1 Quote.
  belongs_to :request

  # Quote has a one-to-one relationship with Job. Quote can have 0 or 1 Job, and Job must belong to exactly one Quote.
  has_one :job

  # Validation
  validates :date, :status, presence: true
  validates :service_hour, :total_cost, numericality: { greater_than: 0 }, on: :update
end
