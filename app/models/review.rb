class Review < ApplicationRecord
  belongs_to :job
  belongs_to :review_from, class_name: "Profile", optional: true
  belongs_to :review_to, class_name: "Profile", optional: true

  # Validation
  validates :rating, presence: true
end
