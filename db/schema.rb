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

ActiveRecord::Schema[7.2].define(version: 2025_06_01_113224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "blog_likes", force: :cascade do |t|
    t.bigint "blog_id", null: false
    t.bigint "blogger_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id", "blogger_id"], name: "index_blog_likes_on_blog_id_and_blogger_id", unique: true
    t.index ["blog_id"], name: "index_blog_likes_on_blog_id"
    t.index ["blogger_id"], name: "index_blog_likes_on_blogger_id"
  end

  create_table "bloggers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_bloggers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_bloggers_on_reset_password_token", unique: true
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "status"
    t.string "thumb_nail_url"
    t.integer "view_count"
    t.integer "likes_count"
    t.datetime "published_at"
    t.bigint "blogger_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blogger_id"], name: "index_blogs_on_blogger_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumb_nail_url"
    t.string "goal"
    t.string "location"
    t.bigint "founder_id"
    t.boolean "is_get_donated"
    t.index ["founder_id"], name: "index_campaigns_on_founder_id"
  end

  create_table "donations", force: :cascade do |t|
    t.decimal "amount"
    t.string "currency"
    t.string "frequency"
    t.string "full_name"
    t.boolean "subscribe_newsletter"
    t.boolean "include_name"
    t.string "stripe_session_id"
    t.string "stripe_customer_id"
    t.string "stripe_payment_id"
    t.string "stripe_subscription_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "donation_type"
    t.bigint "campaign_id"
    t.string "session_id"
    t.index ["campaign_id"], name: "index_donations_on_campaign_id"
    t.index ["session_id"], name: "index_donations_on_session_id", unique: true
    t.index ["stripe_session_id"], name: "index_donations_on_stripe_session_id", unique: true
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities_sections", id: false, force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.bigint "section_id", null: false
    t.index ["facility_id", "section_id"], name: "index_facilities_sections_on_facility_id_and_section_id"
    t.index ["section_id", "facility_id"], name: "index_facilities_sections_on_section_id_and_facility_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_images_on_game_id"
  end

  create_table "item_relationships", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "related_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_relationships_on_item_id"
    t.index ["related_item_id"], name: "index_item_relationships_on_related_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "section_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.boolean "can_recycle"
    t.text "life_cycle"
    t.text "recycle_way"
    t.index ["section_id"], name: "index_items_on_section_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "body"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "subscriber_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_participants_on_campaign_id"
    t.index ["subscriber_id"], name: "index_participants_on_subscriber_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_accounts", force: :cascade do |t|
    t.bigint "subscriber_id", null: false
    t.string "stripe_account_id"
    t.string "account_type"
    t.string "status"
    t.string "country"
    t.boolean "details_submitted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_stripe_accounts_on_subscriber_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "nickname"
    t.string "full_name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "location"
    t.integer "points"
    t.string "role"
    t.integer "recycling_goal"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wastes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "image"
    t.string "waste_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wastes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blog_likes", "bloggers"
  add_foreign_key "blog_likes", "blogs"
  add_foreign_key "blogs", "bloggers"
  add_foreign_key "campaigns", "subscribers", column: "founder_id"
  add_foreign_key "donations", "campaigns"
  add_foreign_key "images", "games"
  add_foreign_key "item_relationships", "items"
  add_foreign_key "item_relationships", "items", column: "related_item_id"
  add_foreign_key "items", "sections"
  add_foreign_key "notifications", "users"
  add_foreign_key "participants", "campaigns"
  add_foreign_key "participants", "subscribers"
  add_foreign_key "stripe_accounts", "subscribers"
  add_foreign_key "wastes", "users"
end
