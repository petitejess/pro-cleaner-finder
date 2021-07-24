class State < ApplicationRecord
  has_many :postcodes

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
