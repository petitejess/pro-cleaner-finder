class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  before_action :set_job, :set_listing, only: [:edit, :update]
  after_action :set_reviewer, only: [:update]

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { redirect_to @review, notice: "Something went wrong. Please review your submission." }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      # Redirect to job upon review submission
      if @review.update(review_params)
        format.html { redirect_to job_path(@job), notice: "Review was successfully created." }
      else
        format.html { redirect_to @review, notice: "Something went wrong. Please review your submission." }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_job
      # Get the job associated with current review
      @job = Job.find(@review.job_id)
    end

    def set_listing
      # Get the listing associated with current review
      @listing = Listing.find(@review.job.quote.request.listing_id)
    end

    def set_reviewer
      # Set id for review_from and review_to
      @review.update(review_from: @job.quote.request.property.profile_id, review_to: @listing.profile_id)
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:rating, :content, :job_id, :review_from, :review_to, :profile_id)
    end
end
