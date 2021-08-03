class Payment < ApplicationRecord
  # Payment has a one-to-one relationship with Job. Payment must belongs to exactly one Job, and Job may have 0 or 1 Payment.
  belongs_to :job
end
