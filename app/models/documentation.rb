class Documentation < ApplicationRecord
  # Documentation has a one-to-one relationship with Profile. Documentation must belong to exactly one Profile, and Profile must have exactly 1 Documentation.
  belongs_to :profile

  # Validation
  validates :npc_reference, :abn_number, presence: true
  validates_format_of :abn_number, with: /[0-9 ]+/
end
