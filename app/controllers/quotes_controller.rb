class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]
  before_action :set_listing, except: [:index]

  # GET /quotes or /quotes.json
  def index
    # Display only quotes related to current user:
    # Initialise variables

    @quotes = []
    # Get current user's profile id
    profile_id = current_user.profile.id

    if current_user.profile.user_type == "pro"
      # If user is Cleaner, eager loading for all listings owned
      listings = Listing.with_attached_image.where(profile_id: profile_id)
      
      # Only if Cleaner has any listing
      if listings.any?
        # Get all requests
        requests = Request.where(listing_id: listings.pluck(:id))
      end
    else
      # If user is Customer get property
      property = Property.find_by(profile_id: profile_id)
      # Get all requests made
      requests = Request.where(property_id: property.id)
    end

    # Get all quotes
    @quotes = Quote.where(request_id: requests.pluck(:id))
 
    # Check if no open quotes
    quote_open = []
    @quotes.each do |quote|
      # Check quote status
      if quote.status.downcase != "quote accepted."
        quote_open << quote
      end
    end

    # Return true if there are no open quote, of false if there is any open quote
    @no_open_quotes = quote_open.length == 0 ? true : false
  end

  # GET /quotes/1 or /quotes/1.json
  def show
    # Get all reviews associated with owner of the listing
    all_reviews = Review.where(review_to: @listing.profile_id)
    @reviews = []
    all_reviews.each do |review|
      # Get only reviews for this listing
      if review.job.quote.request.listing_id == @listing.id
        @reviews << review
      end
    end
    @review_details = []
    @reviews.each do |review|
      # Get the profile of the reviewer
      reviewer = Profile.find(review.review_from)
      # Prepare review details to be displayed in te view
      @review_details << [review.id, @listing.title, reviewer.first_name, reviewer.last_name.first + ".", reviewer, review.rating, review.content]
    end
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes or /quotes.json
  def create
    @quote = Quote.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "Quote was successfully created." }
        format.json { render :show, status: :created, location: @quote }
      else
        # Show user error messages
        flash[:error] = @quote.errors.full_messages.join(". ")
        flash.keep(:error)
        
        format.html { redirect_to @quote, notice: "Something went wrong. Please review your submission." }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: "Quote was successfully updated." }
        format.json { render :show, status: :ok, location: @quote }
      else
        # Show user error messages
        flash[:error] = @quote.errors.full_messages.join(". ")
        flash.keep(:error)

        format.html { redirect_to @quote, notice: "Something went wrong. Please review your submission." }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    def set_listing
      # Set listing associated with this quote
      @listing = @quote.request.listing
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(:date, :service_hour, :total_cost, :status, :request_id)
    end
end
