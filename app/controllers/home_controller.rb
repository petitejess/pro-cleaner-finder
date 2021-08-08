class HomeController < ApplicationController
  # Allow vistor to see homepage without login
  skip_before_action :authenticate_user!

  def index
    @listings = Listing.all
  end

  def search
    # Initialise all necessary instances
    @query = params[:query].strip.downcase
    all_listings = Listing.all
    service_areas = []
    listing_ids = []
    @listings = []

    # To search listings with postcode number as query:
    if @query =~ /^[0-9]{4}$/
      # Check if postcode number query exists
      suburb = Suburb.find_by(postcode: @query.to_i)
      if suburb
        # 1. Get all service areas that have the suburb id
        service_areas << ServiceArea.where(suburb_id: suburb.id)

        # 2. Get all listing ids from service areas
        service_areas.each do |areas|
          areas.each do |service_area|
            listing_ids << service_area.listing_id
          end
        end

        # 3. Remove duplicate listing ids
        listing_ids.uniq!
      end
    elsif @query =~ /^\w+/
      # To search listings with suburb name as query:
      # Check if suburb name query exists
      suburbs = Suburb.where('suburb ILIKE ?', "%#{@query}%")
      if suburbs.any?
        suburbs.each do |suburb|
          if suburb.suburb.downcase == @query
            # 1. Get all service areas that has suburb.id
            service_areas = ServiceArea.where(suburb_id: suburb.id)
  
            # 2. Get all listing ids from service areas
            service_areas.each do |service_area|
              listing_ids << service_area.listing_id
            end
  
            # 3. Remove duplicate listing ids
            listing_ids.uniq!
            break
          end
        end
      end
    else
      # Return empty array if query is not found
      return @listings
    end
    
    # Loop through listing ids to get the listings
    listing_ids.each do |listing_id|
      @listings << all_listings.find(listing_id)
    end
  end

  def coming_soon
  end
end
