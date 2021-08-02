class Payment < ApplicationRecord
  belongs_to :job

  # Validation
  # validates :payment_date, :payment_method, :payment_amount, presence: true
end
