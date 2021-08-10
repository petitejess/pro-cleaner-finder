class HomeController < ApplicationController
  # Allow vistor to see homepage without login
  skip_before_action :authenticate_user!

  def index
    # Eager loading for @listings with images attached
    @listings = Listing.with_attached_image.all
  end

  def search
    # Sanitise variable
    @query = params[:query].strip.downcase
    # Initialise variables
    @listings = []

    # To check if query is postcode or suburb name with regex
    if @query =~ /^[0-9]{4}$/
      # Check if postcode number query exists
      suburbs = Suburb.where(postcode: @query.to_i)
    elsif @query =~ /^\w+/
      # Check if suburb name query exists and sanitise using parameterised statement
      suburbs = Suburb.where('suburb ILIKE ?', "%#{@query}%")
    end

    # If any suburbs exist
    if suburbs.any?
      # Ger all service areas that have the suburbs ids
      service_areas = ServiceArea.where(suburb_id: suburbs.pluck(:id))
      # Eager loading for @listings with images attached
      @listings = Listing.with_attached_image.where(id: service_areas.pluck(:listing_id).uniq)
    end
  end

  def coming_soon
  end
end
