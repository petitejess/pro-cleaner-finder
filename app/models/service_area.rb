class ServiceArea < ApplicationRecord
  belongs_to :suburb
  belongs_to :listing
end
