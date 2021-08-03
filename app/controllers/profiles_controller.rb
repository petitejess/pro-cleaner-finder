class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action :set_states, :set_postcodes, :set_suburbs, :set_property, :set_documentation
  before_action :set_initial_user_type, only: [:new, :create]
  before_action :set_user_type, only: [:edit, :show, :update]
  before_action :set_reviews, only: [:show]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    # Show only details belonging to current profile
    @documentation = Documentation.find_by(profile_id: params[:id])
    
    @reviews = Review.where(review_to: @profile.id)
    @review_details = []
    @reviews.each do |review|
      reviewer = Profile.find(review.review_from)
      listing_id = Request.find(Quote.find(Job.find(review.job_id).quote_id).request_id).listing_id
      reviewed_listing = Listing.find(listing_id)
      @review_details << [review.id, reviewed_listing.title, reviewer.first_name, reviewer.last_name.first + ".", reviewer, review.rating, review.content]
    end

    @property = Property.find_by(profile_id: params[:id])
  end

  # GET /profiles/new
  def new
    @profile = Profile.new

    # Set user type
    if @profile.user_type == nil
      @profile.user_type = @initial_user_type
    end

    @profile.build_documentation
    @profile.build_property
  end

  # GET /profiles/1/edit
  def edit
    if !(current_user.profile.documentation)
      @profile.build_documentation
    end
    if !(current_user.profile.property)
      @profile.build_property
    end
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)
    
    # Capture query params being passed
    @suburb_id = params[:suburb_id]

    # Assigned current user id
    @profile.user_id = current_user.id

    respond_to do |format|
      if @profile.save
          # Else if params Cleaner, redirect to jobs page after creating a profile
        if @profile.user_type == "pro"
          format.html { redirect_to jobs_path, notice: "Profile was successfully created." }
        else
          # If params Customer, redirect to to root path after creating a profile
          format.html { redirect_to root_path, notice: "Profile was successfully created." }
        end

        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_initial_user_type
      # If new user, set user type as params (passed from signup form)
      if params[:user_type]
        @initial_user_type = params[:user_type]
      else
        @initial_user_type = session[:user_type]
      end
    end

    def set_user_type
      @user_type = current_user.profile.user_type
    end

    def set_states
      # Get all states stored in states table
      @states = State.all
    end

    def set_postcodes
      # Get all postcodes stored in postcodes table
      @postcodes = Postcode.all
    end

    def set_suburbs
      # Get all suburbs stored in suburbs table
      @suburbs = Suburb.all
    end

    def set_documentation
      @documentation = Documentation.new
    end

    def set_reviews
      @reviews = Review.all
    end

    def set_property
      @property = Property.new
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone, :user_type, :user_id, :image, documentation_attributes: [:npc_reference, :abn_number, :insured], property_attributes: [:property_type, :storey, :bed, :bath, :street_address, :suburb_id, :description])
    end
end
