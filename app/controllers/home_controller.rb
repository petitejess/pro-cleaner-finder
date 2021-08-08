class HomeController < ApplicationController
  # Allow vistor to see homepage without login
  skip_before_action :authenticate_user!

  def index
    @listings = Listing.all
  end

  def search
    # Initialise all necessary instances
    @query = params[:query].strip.downcase
    suburbs = Suburb.all
    all_listings = Listing.all
    service_areas = []
    listing_ids = []
    @listings = []

    # To search listings with postcode number as query:
    # if @query =~ /^[0-9]{4}$/
    #   # Check if number query exists in postcodes table
    #   if Postcode.find_by(number: @query.to_i)
    #     # 1. Get all suburbs with the postcode in query (multiple suburbs can have same postcode number)
    #     suburbs = Suburb.where(postcode_id: Postcode.find_by(number: @query.to_i).id)

    #     # 2. Loop through suburbs to get suburb.id to search for listings in service areas table (many-to-many relationship between listings and suburbs through service_areas)
    #     suburbs.each do |suburb|
    #       service_areas << ServiceArea.where(suburb_id: suburb.id)
    #     end

    #     # 3. Get all listing ids from service areas
    #     service_areas.each do |areas|
    #       areas.each do |service_area|
    #         listing_ids << service_area.listing_id
    #       end
    #     end

    #     # 4. Remove duplicate listing ids
    #     listing_ids.uniq!
    #   end
    # elsif @query =~ /^\w+/
    #   # To search listings with suburb name as query:
    #   # Loop through suburbs to get all suburb ids (same suburb names with different postcodes exist)
    #   suburbs.each do |suburb|
    #     if suburb.suburb.downcase == @query
    #       # 1. Get all service areas that has suburb.id
    #       service_areas = ServiceArea.where(suburb_id: suburb.id)

    #       # 2. Get all listing ids from service areas
    #       service_areas.each do |service_area|
    #         listing_ids << service_area.listing_id
    #       end

    #       # 3. Remove duplicate listing ids
    #       listing_ids.uniq!
    #       break
    #     end
    #   end
    # else
    #   # Return empty array if query is not found
    #   return @listings
    # end
    
    # Loop through listing ids to get the listings
    listing_ids.each do |listing_id|
      @listings << all_listings.find(listing_id)
    end
  end

  def coming_soon
  end
end
