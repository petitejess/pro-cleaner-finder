class Review < ApplicationRecord
  belongs_to :job
  belongs_to :reviewer, class_name: "Profile", optional: true
  belongs_to :reviewee, class_name: "Profile", optional: true
end
