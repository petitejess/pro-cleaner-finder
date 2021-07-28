class ListingsController < ApplicationController
  # Allow visitor to see individual listing without login
  skip_before_action :authenticate_user!, only: [:show]

  before_action :set_listing, only: %i[ show edit update destroy ]
  before_action :set_profile, :set_suburbs, :set_request
  before_action :set_service_areas, except: [:edit, :update]

  # GET /listings or /listings.json
  def index
    # If user is logged in, get current user's listings
    if current_user && (@profile.user_type == "pro")
      @listings = Listing.where(profile_id: @profile.id)
    end
  end

  # GET /listings/1 or /listings/1.json
  def show
    # Get service areas for this listing
    @service_areas = ServiceArea.where(listing_id: params[:id])
  end

  # GET /listings/new
  def new
    @listing = Listing.new
    4.times { @listing.service_areas.build }
  end

  # GET /listings/1/edit
  def edit
    if !(@service_areas)
      @listing.service_areas.build
    end
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)

    # Assigned current user's profile id
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
      # If user is logged in
      if current_user
        # Gets current user's profile
        @profile = Profile.find_by(user_id: current_user.id)
      end
    end

    def set_suburbs
      # Get all suburbs stored in suburbs table
      @suburbs = Suburb.all
    end

    def set_service_areas
      @service_areas = ServiceArea.new
    end

    def set_request
      @request = Request.new
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :description, :rate_per_hour, :profile_id, :image, service_areas_attributes: [:id, :suburb_id, :listing_id])
    end
end
