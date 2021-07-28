json.extract! request, :id, :service_date, :start_time, :listing_id, :property_id, :created_at, :updated_at
json.url request_url(request, format: :json)
