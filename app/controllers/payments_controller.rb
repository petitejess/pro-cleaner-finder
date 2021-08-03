class PaymentsController < ApplicationController
  def create
    # Get the job
    @job = Job.find(params[:job_id])

    # Get root path
    if ENV['RAILS_ENV'] == "development"
      root_path = "http://localhost:3000"
    else
      root_path = ENV['ROOT_PATH']
    end

    # Implement stripe key
    Stripe.api_key = Rails.application.credentials.dig(:stripe_api_key)

    session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'aud',
            product_data: {
              name: "Payment for Job ##{@job.id}",
            },
            unit_amount: @job.total_cost.to_i * 100,
          },
          quantity: 1,
        }],
        mode: 'payment',
        # These placeholder URLs will be replaced in a following step.
        # Upon success, redirect to job show page to get the Customer to leave a review
        success_url: "#{root_path}/jobs/#{@job.id}?checkout=success",

        # If payment is cancelled redirect to cancel page
        cancel_url: "#{root_path}/payment/cancel"
      })
    
      redirect_to session.url
  end

  def cancel
  end
end
