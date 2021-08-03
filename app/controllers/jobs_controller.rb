class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :set_review, :set_payment, only: [:show]
  after_action :update_quote_status, :create_review, only: [:create]

  # GET /jobs or /jobs.json
  def index
    # Display only jobs related to current user:
    # Initialise variables
    requests = []
    quotes = []

    # Get current user's profile id
    profile_id = current_user.profile.id

    if current_user.profile.user_type == "pro"
      # If user is Cleaner get all listings owned
      listings = Listing.where(profile_id: profile_id)
      listing_ids= []
      listings.each do |listing|
        # Get the listing ids
        listing_ids << listing.id
      end

      # Only if Cleaner has any listing
      if listing_ids.length > 0
        listing_ids.each do |listing_id|
          # Get all requests received
          requests << Request.where(listing_id: listing_id)
        end
        requests.each do |request|
          request.each do |r|
            # Get all quotes sent
            quotes << Quote.find_by(request_id: r.id)
          end
        end
      end
    else
      # If user is Customer get property
      property = Property.find_by(profile_id: profile_id)
      # Get all requests made
      requests = Request.where(property_id: property.id)
      requests.each do |request|
        # Get all quotes received
        quotes << Quote.find_by(request_id: request.id)
      end
    end

    # Removes nil
    quotes.compact!
    @jobs = []
    quotes.each do |quote|
      # Get all jobs for the quotes
      @jobs << Job.find_by(quote_id: quote.id)
    end

    # Removes nil
    @jobs.compact!
  end

  # GET /jobs/1 or /jobs/1.json
  def show
    # If payment is successful
    if params[:checkout] == "success"
      # Update payment details
      @payment.job_id = @job.id
      @payment.payment_date = Time.current
      @payment.payment_method = "card"
      @payment.payment_amount = @job.total_cost
      @payment.save
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    # Create job based on accepted quote
    @job = Job.new(date: params[:date], service_hour: params[:service_hour], total_cost: params[:total_cost], quote_id: params[:quote_id])

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        # Show user error messages
        flash[:error] = @job.errors.full_messages.join(". ")
        flash.keep(:error)

        format.html { redirect_to @job, notice: "Something went wrong. Please review your submission." }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        # Show user error messages
        flash[:error] = @job.errors.full_messages.join(". ")
        flash.keep(:error)
        
        format.html { redirect_to @job, notice: "Something went wrong. Please review your submission." }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    def update_quote_status
      # After Customer accepts the quote, and quote becomes a job, change the quote status to accepted
      quote = Quote.find(@job.quote_id)
      quote.update(status: "Quote accepted.")
    end

    def create_review
      # After a quote becomes a job, create review based on created job
      review = Review.new(job_id: @job.id, profile_id: @job.quote.request.property.profile_id)
      review.save
    end

    def set_payment
      # Get payment associated with this job
      @payment = Payment.find_by(job_id: @job.id)
      # If no payment associated with this job, create new instance
      if !(@payment)
        @payment = Payment.new
      end
    end

    def set_review
      # To check if a review has been left for this job
      @review = Review.find_by(job_id: @job.id)

      if @review.review_from != nil
        reviewer = Profile.find(@review.review_from)
        @review_details = []
        # Prepare review details to be shown in the view
        @review_details << [@review.id, @job.quote.request.listing.title, reviewer.first_name, reviewer.last_name.first + ".", reviewer, @review.rating, @review.content]
      end
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:date, :service_hour, :total_cost, :status, :quote_id)
    end
end
