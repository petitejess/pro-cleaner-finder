class ListingsController < ApplicationController
  # Allow visitor to see listings without login
  skip_before_action :authenticate_user!, only: [:show]

  before_action :set_listing, only: %i[ show edit update destroy ]
  before_action :set_profile, :set_request
  before_action :set_service_areas, only: [:edit, :show]
  before_action :update_service_areas_record, only: [:update]
  after_action :set_service_areas_record, only: [:create]

  # GET /listings or /listings.json
  def index
    # If user is a cleaner, get current user's all listings
    if current_user && (@profile.user_type == "pro")
      @listings = Listing.includes(:profile).where(profile_id: @profile.id)
    end
  end

  # GET /listings/1 or /listings/1.json
  def show
    # Get all reviews owned by cleaner
    all_reviews = Review.includes(:job).where(review_to: @listing.profile_id)

    @reviews = []
    # Loop through all the reviews to get only reviews for this listing
    all_reviews.each do |review|
      if review.job.quote.request.listing_id == @listing.id
        @reviews << review
      end
    end

    @review_details = []
    # Loop through this listings's review to get the details
    @reviews.each do |review|
      # Get the profile of the reviewer
      reviewer = Profile.find(review.review_from)
      # Prepare review details to be displayed in view
      @review_details << [review.id, @listing.title, reviewer.first_name, reviewer.last_name.first + ".", reviewer, review.rating, review.content]
    end
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)

    # Assign current user's profile id
    @listing.profile_id = @profile.id

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def set_profile
      if current_user
        # Gets current user's profile
        @profile = Profile.find_by(user_id: current_user.id)
      end
    end

    def set_service_areas_record
      # Collect params
      suburbs_params = params[:suburbs]
      states_params = params[:states]
      postcodes_params = params[:postcodes]

      # Loop through all accepted params of suburb, state, postcode sets
      suburbs_params.each_with_index do |suburb_params, i|
        if suburb_params != ''
          # Check if each suburb set exists
          suburb_record = Suburb.find_by(suburb: suburb_params, state: states_params[i], postcode: (postcodes_params[i].to_i))
          if !suburb_record
            # Create new suburb set if none exists yet
            suburb_record = Suburb.create(suburb: suburb_params, state: states_params[i], postcode: (postcodes_params[i].to_i))
          end

          # Create new service area if none exists yet
          service_area_record = ServiceArea.find_by(suburb_id: suburb_record.id, listing_id: @listing.id)
          if !service_area_record
            service_area_record = ServiceArea.create(suburb_id: suburb_record.id, listing_id: @listing.id)
          end
        end
      end
    end

    def update_service_areas_record
      # Get existing record of service areas for this listing
      service_areas_existing = ServiceArea.where(listing_id: @listing.id)

      suburbs_existing_id = []
      # Loop through service areas to get the suburb ids
      service_areas_existing.each do |service_area_existing|
        suburbs_existing_id << service_area_existing.suburb_id
      end

      # Collect params
      suburbs_params = params[:suburbs]
      states_params = params[:states]
      postcodes_params = params[:postcodes]
      suburbs_record = []

       # Check service areas input
      suburbs_params.each_with_index do |suburb_params, i|
        if suburb_params != ''
          # Check if each suburb set exists
          suburb_record = Suburb.find_by(suburb: suburb_params, state: states_params[i], postcode: (postcodes_params[i].to_i))
          if !suburb_record
            # Create new suburb set if none exists yet
            suburb_record = Suburb.create(suburb: suburb_params, state: states_params[i], postcode: (postcodes_params[i].to_i))
          end

          # Create new service area if none exists yet
          service_area_record = ServiceArea.find_by(suburb_id: suburb_record.id, listing_id: @listing.id)
          if !service_area_record
            service_area_record = ServiceArea.create(suburb_id: suburb_record.id, listing_id: @listing.id)
          end

          # Collect suburb ids
          suburbs_record << suburb_record.id
        end
      end

       # If existing record not present in new input params, destroy
      suburbs_removed = suburbs_existing_id - suburbs_record
      ServiceArea.where(suburb_id: suburbs_removed).destroy_all     
    end

    def set_service_areas
      # Get service areas for this listing
      @service_areas = ServiceArea.where(listing_id: params[:id])
    end

    def set_request
      # Create new request instance
      @request = Request.new
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :description, :rate_per_hour, :profile_id, :image, suburbs: [], states: [], postcodes: [])
    end
end
