json.extract! listing, :id, :title, :description, :rate_per_hour, :profile_id, :created_at, :updated_at
json.url listing_url(listing, format: :json)
