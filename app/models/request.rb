class Request < ApplicationRecord
  # Request has a many-to-one relationship with Listing. Request must belong to exactly one Listing, and Listing may have 0 or many Requests.
  belongs_to :listing

  # Request has a many-to-one relationship with Property. Request must belong to exactly one Property, and Property may have 0 or many Requests.
  belongs_to :property

  # Request has a one-to-one relationship with Quote. Request can have 0 or 1 Quote, and Quote must belong to exactly one Request.
  has_one :quote

  # Validation
  validates :service_date, :start_time, presence: true
end
