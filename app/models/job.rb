class Job < ApplicationRecord
  # Job has a one-to-one relationship with Quote. Job must belong to exactly one Quote, and Quote may have 0 or 1 Job.
  belongs_to :quote

  # Job has a one-to-one relationship with Payment. Job may have 0 or 1 Payment, and Payment must belong to exactly one Job.
  has_one :payment

  # Job has a one-to-one relationship with Review. Job may have 0 or 1 Review, and Review must belong to exactly one Job.
  has_one :review

  # Validation
  validates :date, :service_hour, :total_cost, presence: true
end
