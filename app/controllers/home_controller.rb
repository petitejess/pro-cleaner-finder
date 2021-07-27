class HomeController < ApplicationController
  # Allow vistor to see homepage without login
  skip_before_action :authenticate_user!

  def index
    @listings = Listing.all
  end

  def search
    @query = params[:query].downcase
    all_listings = Listing.all
    suburbs = Suburb.all
    postcodes = Postcode.all
    service_areas = []
    listing_ids = []
    @listings = []

    if @query =~ /^[0-9]{4}$/
      # If search query is postcode
      postcodes.each do |postcode|
        if @query.to_i == postcode.number
          suburbs.each do |suburb|
            if postcode.id == suburb.postcode_id
              service_areas = ServiceArea.where(suburb_id: suburb.id)
              service_areas.each do |service_area|
                listing_ids << service_area.listing_id
              end

              listing_ids.uniq!
              break
            end
          end
        end
      end
    elsif @query =~ /^\w+/
      # If search query is suburb name
      suburbs.each do |suburb|
        if @query == suburb.name.downcase
          service_areas = ServiceArea.where(suburb_id: suburb.id)
          service_areas.each do |service_area|
            listing_ids << service_area.listing_id
          end

          listing_ids.uniq!
          break
        end
      end
    else
      return @listings
    end
    
    listing_ids.each do |listing_id|
      @listings << all_listings.find(listing_id)
    end
  end
end
