class Review < ApplicationRecord
  # Review has a one-to-one relationship with Job. Review must belongs to exactly one Job, and Job may have 0 or 1 Review.
  belongs_to :job

  # Review has a one-to-one relationship with Profile. Review must belongs to exactly one Profile, and Profile may have 0 or 1 Review.
  belongs_to :reviewer, class_name: "Profile", optional: true
  belongs_to :reviewee, class_name: "Profile", optional: true
end
