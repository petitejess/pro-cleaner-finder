class ServiceArea < ApplicationRecord
  # ServiceArea acts as a join table between Suburb and Listing

  # ServiceArea has a many-to-one relationship with Suburb. ServiceArea must belong to exactly 1 Suburb, and Suburb may have 1 or many ServiceArea.
  belongs_to :suburb

  # ServiceArea has a many-to-one relationship with Listing. Listing must belong to exactly 1 Listing, and Listing may have 1 or many ServiceArea.
  belongs_to :listing
end
