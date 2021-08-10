require 'faraday'
require 'json'

class SuburbsController < ApplicationController
  before_action :set_suburbs, only: [:index]

  def index
    # Render the collected suburbs in json format in view
    respond_to do |format|
      format.json { render json: @suburbs.to_json }
    end
  end

  private

  def set_suburbs
    @suburbs = []

    # Get the possible suburbs from Postcode API based on user input passed as params :term
    if params[:term]
      url = 'https://v0.postcodeapi.com.au/suburbs.json'
      # Use faraday gem to handle the HTTP request
      response = Faraday.get(url, {q: params[:term]}, {'Accept' => 'application/json; indent=4'})
      results = JSON.parse(response.body)
      results.each do |result|
        # Not to include PO Boxes (https://en.wikipedia.org/wiki/Postcodes_in_Australia)
        if result["postcode"].in?([*1..9999] - [*200..299, *900..999, *1000..1999, *5800..5999, *6800..6999, *7800..7999, *8000..8999, *9000..9999])
          # Collect valid postcodes (format following json from Postcode API), postcode int to str and format it to allow 0 at front
          @suburbs << {"suburb": result["name"], "state": result["state"]["abbreviation"], "postcode": result["postcode"].to_s.rjust(4, "0")}
        end
      end
    else
      # If no input passed, get all suburbs from database instead
      results = Suburb.all
      results.each do |result|
        @suburbs << {"suburb": result["suburb"], "state": result["state"], "postcode": result["postcode"].to_s.rjust(4, "0")}
      end
    end
  end
end