# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_28_073734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "documentations", force: :cascade do |t|
    t.string "npc_reference"
    t.string "abn_number"
    t.boolean "insured"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_documentations_on_profile_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.date "date"
    t.float "service_hour"
    t.float "total_cost"
    t.bigint "quote_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quote_id"], name: "index_jobs_on_quote_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.float "rate_per_hour"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_listings_on_profile_id"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "payment_date"
    t.string "payment_method"
    t.float "payment_amount"
    t.bigint "job_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_payments_on_job_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "user_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "property_type"
    t.integer "storey"
    t.integer "bed"
    t.integer "bath"
    t.string "street_address"
    t.bigint "suburb_id", null: false
    t.text "description"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_properties_on_profile_id"
    t.index ["suburb_id"], name: "index_properties_on_suburb_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.date "date"
    t.float "service_hour"
    t.float "total_cost"
    t.string "status"
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_quotes_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.date "service_date"
    t.bigint "listing_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.time "start_time"
    t.index ["listing_id"], name: "index_requests_on_listing_id"
    t.index ["property_id"], name: "index_requests_on_property_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "content"
    t.bigint "job_id", null: false
    t.integer "review_from"
    t.integer "review_to"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_reviews_on_job_id"
    t.index ["profile_id"], name: "index_reviews_on_profile_id"
  end

  create_table "service_areas", force: :cascade do |t|
    t.bigint "suburb_id", null: false
    t.bigint "listing_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_service_areas_on_listing_id"
    t.index ["suburb_id"], name: "index_service_areas_on_suburb_id"
  end

  create_table "suburbs", force: :cascade do |t|
    t.string "suburb"
    t.string "state"
    t.integer "postcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "documentations", "profiles"
  add_foreign_key "jobs", "quotes"
  add_foreign_key "listings", "profiles"
  add_foreign_key "payments", "jobs"
  add_foreign_key "profiles", "users"
  add_foreign_key "properties", "profiles"
  add_foreign_key "properties", "suburbs"
  add_foreign_key "quotes", "requests"
  add_foreign_key "requests", "listings"
  add_foreign_key "requests", "properties"
  add_foreign_key "reviews", "jobs"
  add_foreign_key "reviews", "profiles"
  add_foreign_key "service_areas", "listings"
  add_foreign_key "service_areas", "suburbs"
end
