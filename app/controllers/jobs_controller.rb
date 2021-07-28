class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :set_review, only: [:show]
  after_action :update_quote_status, :create_review, only: [:create]

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all
  end

  # GET /jobs/1 or /jobs/1.json
  def show
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
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { render :edit, status: :unprocessable_entity }
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
      # After Customer accept the quote, and quote becomes a job, change the quote status to accepted
      quote = Quote.find(@job.quote_id)
      quote.update(status: "Quote Accepted.")
    end

    def create_review
      # After a quote becomes a job, create review based on created job
      review = Review.new(job_id: @job.id, profile_id: @job.quote.request.property.profile_id)
      review.save
    end

    def set_review
      # To check if a review has been left for this job
      @review = Review.find_by(job_id: @job.id)
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:date, :service_hour, :total_cost, :status, :quote_id)
    end
end
