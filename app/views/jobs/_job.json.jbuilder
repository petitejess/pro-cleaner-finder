json.extract! job, :id, :date, :service_hour, :total_cost, :status, :quote_id, :created_at, :updated_at
json.url job_url(job, format: :json)
