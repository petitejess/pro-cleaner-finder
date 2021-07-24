class Postcode < ApplicationRecord
  belongs_to :state

  has_many :suburbs
end
