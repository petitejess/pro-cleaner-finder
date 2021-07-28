json.extract! review, :id, :rating, :content, :job_id, :review_from, :review_to, :profile_id, :created_at, :updated_at
json.url review_url(review, format: :json)
