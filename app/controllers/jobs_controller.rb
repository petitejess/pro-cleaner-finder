class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :set_review, :set_payment, only: [:show]
  after_action :update_quote_status, :create_review, only: [:create]

  # GET /jobs or /jobs.json
  def index
    # Display only jobs related to current user:
    # Get current user's profile id
    profile_id = current_user.profile.id

    if current_user.profile.user_type == "pro"
      # If user is Cleaner, get all listings owned
      listings = Listing.includes(:requests).where(profile_id: profile_id)
      # Get all requests associated with listings owned
      requests = Request.where(listing_id: listings.pluck(:id))
      
    else
      # If user is Customer, get property
      property = Property.includes(:requests).find_by(profile_id: profile_id)
      # Get all requests made
      requests = Request.where(property_id: property.id)
    end

    # Get all quotes based on requests ids
    quotes = Quote.where(request_id: requests.pluck(:id))
    # Get all jobs owned
    @jobs = Job.where(quote_id: quotes.pluck(:id))
  end

  # GET /jobs/1 or /jobs/1.json
  def show
    # If payment is successful
    if params[:checkout] == "success"
      # Update payment details
      @payment.update(job_id: @job.id, payment_date: Time.current, payment_method: "card", payment_amount: @job.total_cost)
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
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
      review = Review.create(job_id: @job.id, profile_id: @job.quote.request.property.profile_id)
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
        # Get reviewer profile
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
