class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]

  # GET /quotes or /quotes.json
  def index
    # Get only quotes related to current user
    all_quotes = Quote.all
    profile_id = Profile.find_by(user_id: current_user.id).id
    listings = Listing.where(profile_id: profile_id)
    listing_ids = []
    listings.each do |listing|
      listing_ids << listing.id
    end
    property = Property.find_by(profile_id: profile_id)
    requests = []
    @quotes = []
    if listing_ids.length > 0
      listing_ids.each do |listing_id|
        requests << Request.where(listing_id: listing_id)
      end
      requests.each do |request|
        request.each do |r|
          @quotes << Quote.find_by(request_id: r.id)
        end
      end
    elsif property
      requests = Request.where(property_id: property.id)
      requests.each do |request|
        @quotes << Quote.find_by(request_id: request.id)
      end
    end
    # Removes nil
    @quotes.compact!
  end

  # GET /quotes/1 or /quotes/1.json
  def show
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
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: "Quote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(:date, :service_hour, :total_cost, :status, :request_id)
    end
end
