class Profile < ApplicationRecord
  # Profile has a one-to-one relationship with User. Profile must belong to exactly one User, and User has exactly 1 Profile.
  belongs_to :user

  # Profile has a one-to-one relationship with Documentation. Profile has exactly 1 Documentation, and Documentation must belong to exactly one Profile.
  has_one :documentation, inverse_of: :profile, autosave: true, dependent: :destroy
  # Profile accepts attributes for Documentation through nested form
  accepts_nested_attributes_for :documentation, allow_destroy: true
  
  # Profile has a one-to-one relationship with Property. Profile has exactly 1 Property, and Property must belong to exactly one Profile.
  has_one :property, inverse_of: :profile, autosave: true, dependent: :destroy
  # Profile accepts attributes for Property through nested form
  accepts_nested_attributes_for :property, allow_destroy: true

  # Profile can have 0 or 1 image
  has_one_attached :image

  # Profile has a one-to-many relationship with Listing. Profile may have 0 or many Listings, and Listing must belong to exactly 1 Profile.
  has_many :listings

  # Profile has a one-to-many relationship with Review. Profile may have 0 or many Reviews, and Review must belong to exactly 1 Profile.
  has_many :reviews_to_make, class_name: "Review", foreign_key: "review_to"
  has_many :reviews_to_receive, class_name: "Review", foreign_key: "review_from"

  # Validation
  validates :first_name, :last_name, :phone, presence: true
  validates_format_of :phone, with: /[0-9 ]+/
end
