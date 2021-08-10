class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action :set_initial_user_type, only: [:new, :create]
  before_action :set_suburb_record, only: [:create, :update]
  before_action :set_user_type, only: [:edit, :show, :update]
  before_action :set_reviews, :set_viewer, only: [:show]
  before_action :set_suburb, only: [:edit, :show]

 # GET /profiles/1 or /profiles/1.json
  def show
    # Show only details belonging to current profile
    if @profile && @profile.user_type == "pro"
      # If user has a profile and is Cleaner:
      # Get the documentation
      @documentation = Documentation.find_by(profile_id: @profile.id)

      # Eager loading for @listings owned with images attached
      @listings = Listing.with_attached_image.where(profile_id: @profile.id)
      
      # Get all reviews owned
      @reviews = Review.includes(:reviewer).where(review_to: @profile.id)
      # Get all requests associated with listings owned
      requests = Request.where(listing_id: @listings.pluck(:id))
      # Get all quotes based on requests ids
      quotes = Quote.where(request_id: requests.pluck(:id))
      # Get all jobs owned
      jobs = Job.where(quote_id: quotes.pluck(:id))

      @review_details = []
      # Loop through each review to get all details to be shown
      @reviews.each do |review|
        # Get the reviewer profile
        reviewer = Profile.find(review.review_from)
        
        # Get the listings owned that have reviews
        reviewed_listing = @listings.find(requests.find(quotes.find(jobs.find(review.job_id).quote_id).request_id).listing_id)

        # Prepare review details to be shown in the view
        @review_details << [review.id, reviewed_listing.title, reviewer.first_name, reviewer.last_name.first + ".", reviewer, review.rating, review.content]
      end
    else
      # If user is Customer, show the property information
      @property = Property.find_by(profile_id: @profile.id)
    end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new

    # Set user type if not yet set
    if @profile.user_type == nil
      @profile.user_type = @initial_user_type
    end

    # Build nested form
    @profile.build_documentation
    @profile.build_property
  end

  # GET /profiles/1/edit
  def edit
    # Build nested form if user hasn't enter anything upon profile creation
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

    # If a customer
    if @profile.user_type == "customer"
      # Set suburb_id for their property
      @profile.property.suburb_id = @suburb_record.id
    end

    # Assigned current user id
    @profile.user_id = current_user.id

    respond_to do |format|
      if @profile.save
          # If params Cleaner, redirect to my listings page after creating a profile
        if @profile.user_type == "pro"
          format.html { redirect_to listings_path, notice: "Profile was successfully created." }
        else
          # Else if params Customer, redirect to to root path after creating a profile
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
    # If a customer
    if @profile.user_type == "customer"
      # Set suburb_id for their property
      @profile.property.suburb_id = @suburb_record.id
    end

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
        # If somehow params is lost (user navigates away), use the one stored in session
        @initial_user_type = session[:user_type]
      end
    end

    def set_user_type
      # If existing user, get user type form profile
      @user_type = current_user.profile.user_type
    end

    def set_viewer
      # If user is signed in and has a profile
      if user_signed_in? && current_user.profile
        # Set the viewer as current user's profile
        @viewer = current_user.profile
      else
        @viewer = "visitor"
      end
    end

    def set_suburb_record
      # If user has a profile and is a customer or if the current session has user type as customer
      if (current_user.profile && @profile.user_type == "customer") || session[:user_type] == "customer"
        # Check if suburb set already exists in database
        @suburb_record = Suburb.find_by(suburb: params[:suburb], state: params[:state], postcode: (params[:postcode].to_i))
        
        # If doesn't exist
        if !@suburb_record
          # Create new suburb set
          @suburb_record = Suburb.create(suburb: params[:suburb], state: params[:state], postcode: (params[:postcode].to_i))
        end
      end
    end

    def set_suburb
      # If user has a profile and is a customer or if the current session has user type as customer
      if current_user.profile && current_user.profile.user_type == "customer" || session[:user_type] == "customer"
        # Get existing details (suburb, state, postcode) of profile
        @suburb = current_user.profile.property.suburb
      end
    end

    def set_reviews
      # Get all reviews stored in reviews table
      @reviews = Review.all
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone, :user_type, :user_id, :image, documentation_attributes: [:id, :npc_reference, :abn_number, :insured], property_attributes: [:id, :property_type, :storey, :bed, :bath, :street_address, :suburb, :state, :postcode, :description])
    end
end
