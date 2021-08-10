class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy ]
  before_action :set_property, only: [:create]

  # GET /requests/new
  def new
    @request = Request.new()
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)

    # Set property_id in request
    @request.property_id = @property.id

    respond_to do |format|
      if @request.save
        # After Customer create a request for a quote, create a new quote in database
        create_quote

        # Redirect to quote index upon request submission
        format.html { redirect_to quote_url(@quote), notice: "Request was successfully created." }
      else
        # Show user error messages
        flash[:error] = @request.errors.full_messages.join(". ")
        flash.keep(:error)

        format.html { redirect_to listing_url(@request.listing), notice: "Something went wrong. Please review your submission." }
      end
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: "Request was successfully updated." }
        format.json { render :show, status: :ok, location: @request }
      else
        # Show user error messages
        flash[:error] = @request.errors.full_messages.join(". ")
        flash.keep(:error)
        
        format.html { redirect_to listing_url(@request.listing), notice: "Something went wrong. Please review your submission." }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    def set_property
      # Get Customer's property and set to request attribute for property id
      @property = Property.find_by(profile_id: Profile.find_by(user_id: current_user.id))
    end

    def create_quote
      # After Customer create a request for a quote, create a new quote in database
      @quote = Quote.create(date: @request.created_at.to_date, request_id: @request.id, status: "Request for a quote.")
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:service_date, :start_time, :listing_id)
    end
end
