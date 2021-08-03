class PaymentsController < ApplicationController
  def create
    # Fetch the job
    @job = Job.find(params[:job_id])

    # do not update buyer before successfully have the payment through
    # # update the buyer
    # @listing.buyer_id = current_user.profile.id
    # @listing.save

    # Fetch root path
    if ENV['RAILS_ENV'] == "development"
      root_path = "http://localhost:3000"
    else
      root_path = ENV['ROOT_PATH']
    end

    # Implement stripe code
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
        # upon success redirect to listing show page, may be get the buyer to leave a review (string interpolation ruby needs to be surrounded by DOUBLE quote not single quote)
        success_url: "#{root_path}/jobs/#{@job.id}?checkout=success",

        # if payment cancelled show a cancel msg
        cancel_url: "#{root_path}/payment/cancel"
      })
    
      redirect_to session.url
  end

  def cancel
  end
end
