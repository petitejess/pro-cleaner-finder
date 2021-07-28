class Quote < ApplicationRecord
  belongs_to :request
  has_one :job

  # Validation
  validates :date, :status, presence: true
end
