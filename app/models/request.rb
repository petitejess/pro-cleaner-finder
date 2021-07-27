class Request < ApplicationRecord
  belongs_to :listing
  belongs_to :property
  has_one :quote

  # Validation
  validates :service_date, :start_time, presence: true
end
