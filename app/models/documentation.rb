class Documentation < ApplicationRecord
  belongs_to :profile

  # Validation
  validates :npc_ref, :abn_number, presence: true
  validates :abn_number, numericality: true, length: { minimum: 9, maximum: 11 }
end
