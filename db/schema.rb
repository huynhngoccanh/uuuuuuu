# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170123095045) do

  create_table "admin_commissions", force: :cascade do |t|
    t.float    "commission_amount", limit: 24
    t.integer  "user_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "password_salt",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.string   "user_id",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "expire",       limit: 255
    t.string   "device_id",    limit: 255
  end

  create_table "archived_bids", force: :cascade do |t|
    t.integer  "auction_id", limit: 4
    t.integer  "vendor_id",  limit: 4
    t.decimal  "max_value",            precision: 8, scale: 2
    t.datetime "bid_at"
  end

  create_table "auction_addresses", force: :cascade do |t|
    t.integer  "auction_id", limit: 4
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "address",    limit: 255
    t.string   "city",       limit: 255
    t.string   "zip_code",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auction_images", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "auction_id",         limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auction_outcome_vendors", force: :cascade do |t|
    t.integer  "auction_outcome_id", limit: 4
    t.integer  "vendor_id",          limit: 4
    t.boolean  "accepted"
    t.text     "comment",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto_accepted"
  end

  create_table "auction_outcomes", force: :cascade do |t|
    t.integer  "auction_id",              limit: 4
    t.boolean  "purchase_made"
    t.datetime "confirmed_at"
    t.datetime "first_reminder_sent_at"
    t.datetime "second_reminder_sent_at"
    t.text     "comment",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auctions", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "user_id",                  limit: 4
    t.integer  "service_category_id",      limit: 4
    t.string   "status",                   limit: 255
    t.boolean  "product_auction",                                                default: false
    t.integer  "duration",                 limit: 4
    t.string   "budget",                   limit: 255
    t.integer  "min_vendors",              limit: 4
    t.integer  "max_vendors",              limit: 4
    t.datetime "desired_time"
    t.datetime "contact_time"
    t.datetime "contact_time_to"
    t.string   "contact_time_of_day",      limit: 255
    t.string   "vendor_restriction",       limit: 255
    t.text     "extra_info",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "desired_time_to"
    t.string   "contact_way",              limit: 255
    t.integer  "product_category_id",      limit: 4
    t.string   "delivery_method",          limit: 255
    t.integer  "score",                    limit: 4
    t.datetime "end_time"
    t.decimal  "user_earnings",                          precision: 8, scale: 2
    t.integer  "budget_min",               limit: 4
    t.integer  "budget_max",               limit: 4
    t.integer  "claimed_score",            limit: 4
    t.boolean  "from_mobile"
    t.boolean  "loading_affiliate_offers"
  end

  create_table "auctions_vendors", force: :cascade do |t|
    t.integer  "auction_id", limit: 4
    t.integer  "vendor_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avant_advertiser_category_mappings", force: :cascade do |t|
    t.integer  "avant_advertiser_id", limit: 4
    t.integer  "product_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "preferred"
  end

  create_table "avant_advertisers", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "advertiser_id",      limit: 255
    t.string   "advertiser_url",     limit: 255
    t.decimal  "commission_percent",               precision: 8, scale: 2
    t.decimal  "commission_dollars",               precision: 8, scale: 2
    t.text     "params",             limit: 65535
    t.string   "logo_file_name",     limit: 255
    t.string   "logo_content_type",  limit: 255
    t.integer  "logo_file_size",     limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mobile_enabled"
    t.string   "title",              limit: 255
    t.string   "description",        limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "merchant_id",        limit: 4
  end

  add_index "avant_advertisers", ["advertiser_id"], name: "index_avant_advertisers_on_advertiser_id", unique: true, using: :btree

  create_table "avant_commissions", force: :cascade do |t|
    t.string   "commission_id",       limit: 255
    t.integer  "avant_offer_id",      limit: 4
    t.decimal  "price",                             precision: 8, scale: 2
    t.decimal  "commission_amount",                 precision: 8, scale: 2
    t.integer  "auction_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "resulting_balance",                 precision: 8, scale: 2
  end

  create_table "avant_coupons", force: :cascade do |t|
    t.string   "advertiser_name",   limit: 255
    t.string   "advertiser_id",     limit: 255
    t.string   "ad_id",             limit: 255
    t.string   "ad_url",            limit: 255
    t.string   "header",            limit: 255
    t.string   "code",              limit: 255
    t.text     "description",       limit: 65535
    t.date     "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manually_uploaded"
    t.date     "deleted_at"
  end

  add_index "avant_coupons", ["ad_id"], name: "index_avant_coupons_on_ad_id", unique: true, using: :btree

  create_table "avant_offers", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "auction_id",         limit: 4
    t.string   "advertiser_id",      limit: 255
    t.string   "advertiser_name",    limit: 255
    t.decimal  "price",                            precision: 8, scale: 2
    t.string   "buy_url",            limit: 255
    t.decimal  "commission_percent",               precision: 8, scale: 2
    t.decimal  "commission_dollars",               precision: 8, scale: 2
    t.text     "params",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "auction_id",    limit: 4
    t.integer  "vendor_id",     limit: 4
    t.boolean  "is_winning",                                      default: false
    t.decimal  "max_value",               precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_value", limit: 4
    t.integer  "campaign_id",   limit: 4
    t.integer  "offer_id",      limit: 4
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.integer  "vendor_id",                      limit: 4
    t.boolean  "product_campaign",                                                   default: false
    t.string   "score",                          limit: 255
    t.decimal  "max_bid",                                    precision: 8, scale: 2
    t.decimal  "min_bid",                                    precision: 8, scale: 2
    t.decimal  "fixed_bid",                                  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                         limit: 255
    t.decimal  "budget",                                     precision: 8, scale: 2
    t.integer  "score_min",                      limit: 4
    t.integer  "score_max",                      limit: 4
    t.integer  "offer_id",                       limit: 4
    t.datetime "stop_at"
    t.decimal  "total_spent",                                precision: 8, scale: 2
    t.datetime "low_funds_notification_sent_at"
    t.string   "zip_code",                       limit: 255
    t.integer  "zip_code_miles_radius",          limit: 4
    t.integer  "loyalty_program_offer_id",       limit: 4
  end

  add_index "campaigns", ["loyalty_program_offer_id"], name: "index_campaigns_on_loyalty_program_offer_id", using: :btree

  create_table "campaigns_product_categories", force: :cascade do |t|
    t.integer  "campaign_id",         limit: 4
    t.integer  "product_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns_service_categories", force: :cascade do |t|
    t.integer  "campaign_id",         limit: 4
    t.integer  "service_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns_zip_codes", force: :cascade do |t|
    t.integer  "campaign_id", limit: 4
    t.integer  "zip_code_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cj_advertiser_category_mappings", force: :cascade do |t|
    t.integer  "cj_advertiser_id",    limit: 4
    t.integer  "product_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "preferred"
  end

  create_table "cj_advertisers", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "advertiser_id",          limit: 255
    t.string   "sample_link_id",         limit: 255
    t.float    "commission_percent",     limit: 24
    t.float    "commission_dollars",     limit: 24
    t.text     "params",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inactive"
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size",         limit: 4
    t.datetime "logo_updated_at"
    t.float    "max_commission_percent", limit: 24
    t.float    "max_commission_dollars", limit: 24
    t.boolean  "mobile_enabled"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
    t.integer  "merchant_id",            limit: 4
  end

  add_index "cj_advertisers", ["advertiser_id"], name: "index_cj_advertisers_on_advertiser_id", unique: true, using: :btree

  create_table "cj_commissions", force: :cascade do |t|
    t.string   "commission_id",       limit: 255
    t.integer  "cj_offer_id",         limit: 4
    t.decimal  "price",                             precision: 8, scale: 2
    t.decimal  "commission_amount",                 precision: 8, scale: 2
    t.integer  "auction_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "resulting_balance",                 precision: 8, scale: 2
  end

  create_table "cj_coupons", force: :cascade do |t|
    t.string   "header",             limit: 255
    t.string   "code",               limit: 255
    t.text     "description",        limit: 65535
    t.date     "expires_at"
    t.integer  "advertiser_id",      limit: 4
    t.string   "ad_id",              limit: 255
    t.string   "advertiser_type",    limit: 255
    t.boolean  "manually_uploaded",                default: false
    t.integer  "merchant_id",        limit: 4
    t.string   "ad_url",             limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "temp_website",       limit: 255
    t.string   "user_id",            limit: 255
    t.string   "coupon_type",        limit: 255
    t.string   "print_file_name",    limit: 255
    t.string   "print_content_type", limit: 255
    t.integer  "print_file_size",    limit: 4
    t.datetime "print_updated_at"
    t.date     "deleted_at"
    t.integer  "views",              limit: 4
    t.date     "views_updated_at"
    t.datetime "verified_at"
    t.boolean  "verified",                         default: false
  end

  add_index "cj_coupons", ["ad_id"], name: "index_cj_coupons_on_ad_id", unique: true, using: :btree

  create_table "cj_offers", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "auction_id",          limit: 4
    t.string   "ad_id",               limit: 255
    t.string   "advertiser_id",       limit: 255
    t.string   "advertiser_name",     limit: 255
    t.decimal  "price",                             precision: 8, scale: 2
    t.string   "buy_url",             limit: 255
    t.text     "params",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "expected_commission",               precision: 8, scale: 2
    t.boolean  "commission_payed"
    t.decimal  "commission_value",                  precision: 8, scale: 2
  end

  create_table "clicks", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.integer  "resource_id",            limit: 4
    t.string   "resource_type",          limit: 255
    t.text     "url",                    limit: 65535
    t.string   "ip",                     limit: 255
    t.decimal  "cashback_amount",                      precision: 10, scale: 2, default: 0.0
    t.boolean  "eligiable_for_cashback"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.integer  "commissionable_id",      limit: 4
    t.string   "commissionable_type",    limit: 255
    t.string   "commission_amount",      limit: 255
    t.string   "commissionable_confirm", limit: 255
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,    default: ""
    t.text     "comment",          limit: 65535
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "role",             limit: 255,   default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "custom_advertisers", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "advertiser_url",         limit: 255
    t.boolean  "inactive"
    t.boolean  "mobile_enabled",                                             default: false
    t.float    "max_commission_percent", limit: 24
    t.decimal  "max_commission_dollars",             precision: 8, scale: 2
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size",         limit: 4
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                  limit: 255
    t.string   "description",            limit: 255
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "email_contents", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "hello_sub_text", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "send_mail",                    default: true
  end

  create_table "facebookqueries", force: :cascade do |t|
    t.string   "facebook_uid", limit: 255
    t.string   "query",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "favorite_advertisers", force: :cascade do |t|
    t.integer  "user_id",                 limit: 4
    t.integer  "cj_advertiser_id",        limit: 4
    t.integer  "avant_advertiser_id",     limit: 4
    t.integer  "linkshare_advertiser_id", limit: 4
    t.integer  "pj_advertiser_id",        limit: 4
    t.integer  "ir_advertiser_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_advertisers", ["avant_advertiser_id"], name: "index_favorite_advertisers_on_avant_advertiser_id", using: :btree
  add_index "favorite_advertisers", ["cj_advertiser_id"], name: "index_favorite_advertisers_on_cj_advertiser_id", using: :btree
  add_index "favorite_advertisers", ["linkshare_advertiser_id"], name: "index_favorite_advertisers_on_linkshare_advertiser_id", using: :btree
  add_index "favorite_advertisers", ["user_id"], name: "index_favorite_advertisers_on_user_id", using: :btree

  create_table "favorite_merchants", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "advertisable_id",   limit: 4
    t.string   "advertisable_type", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "favorite_merchants", ["user_id"], name: "index_favorite_merchants_on_user_id", using: :btree

  create_table "funds_refunds", force: :cascade do |t|
    t.integer  "vendor_id",         limit: 4
    t.decimal  "requested_amount",              precision: 8, scale: 2
    t.decimal  "refunded_amount",               precision: 8, scale: 2
    t.string   "status",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "resulting_balance",             precision: 8, scale: 2
  end

  create_table "funds_refunds_funds_transfers", force: :cascade do |t|
    t.integer "funds_refund_id",   limit: 4
    t.integer "funds_transfer_id", limit: 4
  end

  create_table "funds_transfer_transactions", force: :cascade do |t|
    t.integer  "funds_transfer_id", limit: 4
    t.string   "action",            limit: 255
    t.decimal  "amount",                          precision: 8, scale: 2
    t.boolean  "success"
    t.string   "authorization",     limit: 255
    t.string   "message",           limit: 255
    t.text     "params",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funds_transfers", force: :cascade do |t|
    t.integer  "vendor_id",         limit: 4
    t.decimal  "amount",                        precision: 8, scale: 2
    t.string   "status",            limit: 255
    t.string   "paypal_token",      limit: 255
    t.string   "paypal_payer_id",   limit: 255
    t.string   "ip_address",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "refunded_amount",               precision: 8, scale: 2
    t.boolean  "use_credit_card"
    t.string   "card_type",         limit: 255
    t.string   "card_first_name",   limit: 255
    t.string   "card_last_name",    limit: 255
    t.string   "card_last_digits",  limit: 255
    t.decimal  "resulting_balance",             precision: 8, scale: 2
  end

  create_table "funds_withdrawal_notifications", force: :cascade do |t|
    t.integer  "funds_withdrawal_id", limit: 4
    t.string   "status",              limit: 255
    t.string   "receiver_email",      limit: 255
    t.string   "transaction_id",      limit: 255
    t.text     "params",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funds_withdrawals", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.decimal  "amount",                          precision: 8, scale: 2
    t.string   "paypal_email",      limit: 255
    t.boolean  "success"
    t.string   "authorization",     limit: 255
    t.string   "message",           limit: 255
    t.text     "params",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "resulting_balance",               precision: 8, scale: 2
  end

  create_table "hp_advertiser_images", force: :cascade do |t|
    t.string   "hp_image_file_name",    limit: 255
    t.string   "hp_image_content_type", limit: 255
    t.integer  "hp_image_file_size",    limit: 4
    t.datetime "hp_image_updated_at"
    t.integer  "imageable_id",          limit: 4
    t.string   "imageable_type",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                 limit: 255
    t.string   "description",           limit: 255
    t.string   "hp_logo_file_name",     limit: 255
    t.string   "hp_logo_content_type",  limit: 255
    t.integer  "hp_logo_file_size",     limit: 4
    t.datetime "hp_logo_updated_at"
  end

  create_table "hp_store_product_categories", force: :cascade do |t|
    t.integer  "hp_store_id",         limit: 4
    t.integer  "product_category_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "hp_store_product_categories", ["hp_store_id"], name: "index_hp_store_product_categories_on_hp_store_id", using: :btree
  add_index "hp_store_product_categories", ["product_category_id"], name: "index_hp_store_product_categories_on_product_category_id", using: :btree

  create_table "hp_stores", force: :cascade do |t|
    t.string   "store_type",              limit: 255
    t.integer  "avant_advertiser_id",     limit: 4
    t.integer  "linkshare_advertiser_id", limit: 4
    t.integer  "cj_advertiser_id",        limit: 4
    t.integer  "pj_advertiser_id",        limit: 4
    t.integer  "ir_advertiser_id",        limit: 4
    t.integer  "custom_advertiser_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "advertiser_id",           limit: 4
    t.string   "advertiser_type",         limit: 255
  end

  create_table "invite_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "status",     limit: 255
    t.string   "token",      limit: 255
  end

  create_table "ir_advertiser_category_mappings", force: :cascade do |t|
    t.integer  "ir_advertiser_id",    limit: 4
    t.integer  "product_category_id", limit: 4
    t.boolean  "preferred"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ir_advertiser_category_mappings", ["ir_advertiser_id"], name: "index_ir_category_mappings_on_adv_id", using: :btree
  add_index "ir_advertiser_category_mappings", ["product_category_id"], name: "index_ir_category_mappings_on_product_id", using: :btree

  create_table "ir_advertisers", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "advertiser_id",          limit: 255
    t.boolean  "inactive"
    t.text     "params",                 limit: 4294967295
    t.boolean  "mobile_enabled",                                                    default: false
    t.float    "max_commission_percent", limit: 24
    t.decimal  "max_commission_dollars",                    precision: 8, scale: 2
    t.string   "generic_link",           limit: 255
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size",         limit: 4
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                  limit: 255
    t.string   "description",            limit: 255
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
    t.integer  "merchant_id",            limit: 4
  end

  create_table "ir_coupons", force: :cascade do |t|
    t.string   "advertiser_name",   limit: 255
    t.string   "advertiser_id",     limit: 255
    t.string   "header",            limit: 255
    t.string   "ad_id",             limit: 255
    t.string   "ad_url",            limit: 255
    t.string   "description",       limit: 255
    t.date     "start_date"
    t.date     "expires_at"
    t.string   "code",              limit: 255
    t.boolean  "manually_uploaded"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "deleted_at"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "model_number",        limit: 255
    t.string   "sku",                 limit: 255
    t.string   "quantity",            limit: 255
    t.string   "item_total",          limit: 255
    t.string   "product_price",       limit: 255
    t.integer  "purchase_history_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "items", ["purchase_history_id"], name: "index_items_on_purchase_history_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.boolean  "like"
    t.boolean  "dislike"
  end

  create_table "linkshare_advertiser_category_mappings", force: :cascade do |t|
    t.integer "linkshare_advertiser_id", limit: 4
    t.integer "product_category_id",     limit: 4
    t.boolean "preferred"
  end

  add_index "linkshare_advertiser_category_mappings", ["linkshare_advertiser_id"], name: "index_linkshare_category_mappings_on_adv_id", using: :btree
  add_index "linkshare_advertiser_category_mappings", ["product_category_id"], name: "index_linkshare_category_mappings_on_product_id", using: :btree

  create_table "linkshare_advertisers", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "advertiser_id",          limit: 4
    t.string   "base_offer_id",          limit: 255
    t.string   "website",                limit: 255
    t.decimal  "max_commission_percent",               precision: 8, scale: 2
    t.decimal  "max_commission_dollars",               precision: 8, scale: 2
    t.text     "params",                 limit: 65535
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_url",               limit: 255
    t.string   "title",                  limit: 255
    t.string   "description",            limit: 255
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
    t.integer  "merchant_id",            limit: 4
  end

  add_index "linkshare_advertisers", ["advertiser_id"], name: "index_linkshare_advertisers_on_advertiser_id", using: :btree

  create_table "linkshare_coupons", force: :cascade do |t|
    t.string   "advertiser_name",   limit: 255
    t.integer  "advertiser_id",     limit: 4
    t.string   "ad_id",             limit: 255
    t.string   "ad_url",            limit: 255
    t.string   "header",            limit: 255
    t.string   "code",              limit: 255
    t.text     "description",       limit: 65535
    t.date     "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manually_uploaded"
    t.date     "deleted_at"
  end

  add_index "linkshare_coupons", ["ad_id"], name: "index_linkshare_coupons_on_ad_id", unique: true, using: :btree
  add_index "linkshare_coupons", ["advertiser_id"], name: "index_linkshare_coupons_on_advertiser_id", using: :btree

  create_table "loyalty_program_coupons", force: :cascade do |t|
    t.integer  "loyalty_program_id",         limit: 4
    t.string   "loyalty_program_name",       limit: 255
    t.string   "header",                     limit: 255
    t.string   "ad_id",                      limit: 255
    t.string   "ad_url",                     limit: 255
    t.text     "description",                limit: 65535
    t.string   "code",                       limit: 255
    t.date     "start_date"
    t.date     "expires_at"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "manually_uploaded",                        default: false
    t.string   "barcode_image_file_name",    limit: 255
    t.string   "barcode_image_content_type", limit: 255
    t.integer  "barcode_image_file_size",    limit: 4
    t.datetime "barcode_image_updated_at"
  end

  add_index "loyalty_program_coupons", ["loyalty_program_id"], name: "index_loyalty_program_coupons_on_loyalty_program_id", using: :btree

  create_table "loyalty_program_offer_images", force: :cascade do |t|
    t.integer  "loyalty_program_id",       limit: 4
    t.integer  "loyalty_program_offer_id", limit: 4
    t.datetime "image_updated_at"
    t.string   "image_file_name",          limit: 255
    t.string   "image_content_type",       limit: 255
    t.integer  "image_file_size",          limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "loyalty_program_offer_images", ["loyalty_program_id"], name: "index_loyalty_program_offer_images_on_loyalty_program_id", using: :btree
  add_index "loyalty_program_offer_images", ["loyalty_program_offer_id"], name: "index_loyalty_program_offer_images_on_loyalty_program_offer_id", using: :btree

  create_table "loyalty_program_offers", force: :cascade do |t|
    t.integer  "loyalty_program_id",       limit: 4
    t.string   "name",                     limit: 255
    t.string   "coupon_code",              limit: 255
    t.string   "offer_url",                limit: 255
    t.text     "offer_description",        limit: 65535
    t.datetime "expiration_time"
    t.boolean  "product_offer"
    t.decimal  "total_spent",                            precision: 8, scale: 2
    t.string   "offer_video_file_name",    limit: 255
    t.string   "offer_video_content_type", limit: 255
    t.integer  "offer_video_file_size",    limit: 4
    t.datetime "offer_video_updated_at"
    t.datetime "deleted_at"
    t.boolean  "is_deleted"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "loyalty_program_offers", ["loyalty_program_id"], name: "index_loyalty_program_offers_on_loyalty_program_id", using: :btree

  create_table "loyalty_programs", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "logo_image_file_name",    limit: 255
    t.string   "logo_image_content_type", limit: 255
    t.integer  "logo_image_file_size",    limit: 4
    t.datetime "logo_image_updated_at"
    t.boolean  "recommended",                         default: false
    t.integer  "vendor_id",               limit: 4
    t.string   "icon_image_file_name",    limit: 255
    t.string   "icon_image_content_type", limit: 255
    t.integer  "icon_image_file_size",    limit: 4
    t.datetime "icon_image_updated_at"
    t.integer  "num_used",                limit: 4
  end

  add_index "loyalty_programs", ["vendor_id"], name: "index_loyalty_programs_on_vendor_id", using: :btree

  create_table "loyalty_programs_users", force: :cascade do |t|
    t.integer  "loyalty_program_id", limit: 4
    t.integer  "user_id",            limit: 4
    t.string   "account_id",         limit: 255
    t.string   "password",           limit: 255
    t.string   "account_number",     limit: 255
    t.string   "status",             limit: 255,   default: "pending"
    t.text     "exception",          limit: 65535
    t.string   "points",             limit: 255
    t.boolean  "is_signup",                        default: false
    t.boolean  "is_hardcoded",                     default: false
    t.integer  "num_used",           limit: 4
    t.date     "last_used_at"
    t.string   "last_name",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loyalty_programs_users", ["loyalty_program_id"], name: "index_loyalty_programs_users_on_loyalty_program_id", using: :btree
  add_index "loyalty_programs_users", ["user_id"], name: "index_loyalty_programs_users_on_user_id", using: :btree

  create_table "mcb_updates", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.date     "alert_date"
    t.integer  "alertable_id",   limit: 4
    t.string   "alertable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_taxons", force: :cascade do |t|
    t.integer  "merchant_id", limit: 4
    t.integer  "taxon_id",    limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "merchants", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "slug",               limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "loyalty_enabled",                  default: false
    t.string   "loyalty_class",      limit: 255
    t.string   "color_palette",      limit: 255,   default: "#eeeeee"
    t.string   "icon_file_name",     limit: 255
    t.string   "icon_content_type",  limit: 255
    t.integer  "icon_file_size",     limit: 4
    t.datetime "icon_updated_at"
    t.integer  "used_counter",       limit: 4
    t.text     "fallback_link",      limit: 65535
    t.boolean  "mobile_enabled",                   default: false
    t.boolean  "mobile_created",                   default: false
    t.integer  "user_id",            limit: 4
    t.integer  "view_counter",       limit: 4
    t.datetime "lastseen"
    t.boolean  "active_status",                    default: false
  end

  create_table "muddleme_transactions", force: :cascade do |t|
    t.string   "kind",              limit: 255
    t.decimal  "amount",                        precision: 8, scale: 2
    t.decimal  "resulting_balance",             precision: 8, scale: 2
    t.integer  "transactable_id",   limit: 4
    t.string   "transactable_type", limit: 255
    t.decimal  "total_amount",                  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "ioa_auid", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "ioat_rt", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "ioatat_ro", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "ioat_tn", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "ioa_uid", unique: true, using: :btree

  create_table "offer_images", force: :cascade do |t|
    t.integer  "vendor_id",          limit: 4
    t.integer  "offer_id",           limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.integer  "vendor_id",                  limit: 4
    t.boolean  "product_offer",                                                    default: false
    t.string   "coupon_code",                limit: 255
    t.string   "offer_url",                  limit: 255
    t.text     "offer_description",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted",                                                       default: false
    t.datetime "expiration_time"
    t.decimal  "total_spent",                              precision: 8, scale: 2
    t.string   "offer_video_file_name",      limit: 255
    t.string   "offer_video_content_type",   limit: 255
    t.integer  "offer_video_file_size",      limit: 4
    t.datetime "offer_video_updated_at"
    t.string   "service_type",               limit: 10
    t.string   "barcode_image_file_name",    limit: 255
    t.string   "barcode_image_content_type", limit: 255
    t.integer  "barcode_image_file_size",    limit: 4
    t.datetime "barcode_image_updated_at"
  end

  add_index "offers", ["service_type"], name: "index_offers_on_service_type", using: :btree

  create_table "payment_histories", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.datetime "requested_date"
    t.decimal  "amount",                     precision: 10, scale: 2
    t.datetime "paid_on"
    t.string   "transaction_id", limit: 255
    t.string   "paypal_email",   limit: 255
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "personal_offers", force: :cascade do |t|
    t.string   "header",                           limit: 255
    t.string   "offer_video_file_name",            limit: 255
    t.string   "offer_video_content_type",         limit: 255
    t.integer  "offer_video_file_size",            limit: 4
    t.datetime "offer_video_updated_at"
    t.string   "offer_barcode_image_file_name",    limit: 255
    t.string   "offer_barcode_image_content_type", limit: 255
    t.integer  "offer_barcode_image_file_size",    limit: 4
    t.datetime "offer_barcode_image_updated_at"
    t.datetime "expiration_date"
    t.integer  "loyalty_program_id",               limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "vendor_id",                        limit: 4
    t.string   "offer_image_file_name",            limit: 255
    t.string   "offer_image_content_type",         limit: 255
    t.integer  "offer_image_file_size",            limit: 4
    t.datetime "offer_image_updated_at"
  end

  add_index "personal_offers", ["loyalty_program_id"], name: "index_personal_offers_on_loyalty_program_id", using: :btree
  add_index "personal_offers", ["vendor_id"], name: "index_personal_offers_on_vendor_id", using: :btree

  create_table "pj_advertiser_category_mappings", force: :cascade do |t|
    t.integer  "pj_advertiser_id",    limit: 4
    t.integer  "product_category_id", limit: 4
    t.boolean  "preferred"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pj_advertiser_category_mappings", ["pj_advertiser_id"], name: "index_pj_category_mappings_on_adv_id", using: :btree
  add_index "pj_advertiser_category_mappings", ["product_category_id"], name: "index_pj_category_mappings_on_product_id", using: :btree

  create_table "pj_advertisers", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "advertiser_id",          limit: 255
    t.boolean  "inactive"
    t.text     "params",                 limit: 4294967295
    t.boolean  "mobile_enabled",                                                    default: false
    t.float    "max_commission_percent", limit: 24
    t.decimal  "max_commission_dollars",                    precision: 8, scale: 2
    t.string   "generic_link",           limit: 255
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size",         limit: 4
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                  limit: 255
    t.string   "description",            limit: 255
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
    t.integer  "merchant_id",            limit: 4
  end

  create_table "pj_coupons", force: :cascade do |t|
    t.string   "advertiser_name",   limit: 255
    t.string   "advertiser_id",     limit: 255
    t.string   "header",            limit: 255
    t.string   "ad_id",             limit: 255
    t.string   "ad_url",            limit: 255
    t.text     "description",       limit: 65535
    t.date     "start_date"
    t.date     "expires_at"
    t.string   "code",              limit: 255
    t.boolean  "manually_uploaded"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "deleted_at"
  end

  create_table "placements", force: :cascade do |t|
    t.integer  "merchant_id",        limit: 4
    t.string   "location",           limit: 255
    t.text     "description",        limit: 65535
    t.string   "code",               limit: 255
    t.date     "expiry"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "last_used"
    t.text     "header",             limit: 65535
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "printable_coupons", force: :cascade do |t|
    t.integer  "user_coupon_id",            limit: 4
    t.string   "coupon_image_file_name",    limit: 255
    t.string   "coupon_image_content_type", limit: 255
    t.integer  "coupon_image_file_size",    limit: 4
    t.datetime "coupon_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry",   limit: 255
    t.integer  "order",      limit: 4
    t.boolean  "popular",                default: false
  end

  add_index "product_categories", ["ancestry"], name: "index_product_categories_on_ancestry", using: :btree

  create_table "product_categories_vendors", force: :cascade do |t|
    t.integer  "product_category_id", limit: 4
    t.integer  "vendor_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_histories", force: :cascade do |t|
    t.string   "store_address",             limit: 255
    t.string   "customer_service_pin",      limit: 255
    t.string   "total",                     limit: 255
    t.string   "product_total",             limit: 255
    t.string   "sales_tax_fees_surcharges", limit: 255
    t.integer  "loyalty_programs_user_id",  limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "purchase_histories", ["loyalty_programs_user_id"], name: "index_purchase_histories_on_loyalty_programs_user_id", using: :btree

  create_table "qualified_pros", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "l_name",        limit: 255
    t.string   "business_name", limit: 255
    t.boolean  "spanish"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "phone",         limit: 255
    t.integer  "service_id",    limit: 4
  end

  create_table "recognize_images", force: :cascade do |t|
    t.integer  "etilize_id",            limit: 4
    t.string   "etilize_image_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "best_buy_id",           limit: 255
    t.string   "best_buy_image_url",    limit: 255
    t.string   "best_buy_product_name", limit: 255
  end

  create_table "referred_visits", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "earnings",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sales_group_id", limit: 4
  end

  create_table "sales_groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales_groups", ["user_id"], name: "index_sales_groups_on_user_id", using: :btree

  create_table "search_avant_commissions", force: :cascade do |t|
    t.string   "commission_id",             limit: 255
    t.integer  "avant_merchant_id",         limit: 4
    t.integer  "resulting_balance",         limit: 4
    t.float    "price",                     limit: 24
    t.float    "commission_amount",         limit: 24
    t.integer  "search_intent_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",                    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_box_messages", force: :cascade do |t|
    t.text     "message",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.string   "type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_box_messages", ["user_id"], name: "index_search_box_messages_on_user_id", using: :btree

  create_table "search_cj_commissions", force: :cascade do |t|
    t.string   "commission_id",             limit: 255
    t.integer  "cj_merchant_id",            limit: 4
    t.integer  "resulting_balance",         limit: 4
    t.float    "price",                     limit: 24
    t.float    "commission_amount",         limit: 24
    t.integer  "search_intent_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",                    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_intent_outcomes", force: :cascade do |t|
    t.integer  "intent_id",               limit: 4
    t.integer  "merchant_id",             limit: 4
    t.boolean  "purchase_made"
    t.datetime "confirmed_at"
    t.datetime "first_reminder_sent_at"
    t.datetime "second_reminder_sent_at"
    t.text     "comment",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_intents", force: :cascade do |t|
    t.string   "search",                       limit: 255,                                         null: false
    t.integer  "user_id",                      limit: 4
    t.date     "search_date",                                                                      null: false
    t.string   "status",                       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "user_earnings",                            precision: 8, scale: 2
    t.boolean  "has_active_service_merchants",                                     default: false
  end

  add_index "search_intents", ["search", "user_id", "search_date"], name: "index_search_intents_on_search_and_user_id_and_search_date", unique: true, using: :btree
  add_index "search_intents", ["search"], name: "index_search_intents_on_search", using: :btree
  add_index "search_intents", ["user_id"], name: "index_search_intents_on_user_id", using: :btree

  create_table "search_ir_commissions", force: :cascade do |t|
    t.string   "commission_id",             limit: 255
    t.integer  "ir_merchant_id",            limit: 4
    t.integer  "resulting_balance",         limit: 4
    t.float    "price",                     limit: 24
    t.float    "commission_amount",         limit: 24
    t.integer  "search_intent_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",                    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_linkshare_commissions", force: :cascade do |t|
    t.string   "commission_id",             limit: 255
    t.integer  "linkshare_merchant_id",     limit: 4
    t.integer  "resulting_balance",         limit: 4
    t.float    "price",                     limit: 24
    t.float    "commission_amount",         limit: 24
    t.integer  "search_intent_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",                    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_merchants", force: :cascade do |t|
    t.string   "company_name",        limit: 255
    t.string   "company_address",     limit: 255
    t.string   "company_url",         limit: 255
    t.string   "offer_name",          limit: 255
    t.string   "coupon_code",         limit: 255
    t.string   "company_phone",       limit: 255
    t.string   "user_money",          limit: 255,                   null: false
    t.string   "offer_buy_url",       limit: 255
    t.string   "company_coupons_url", limit: 255
    t.integer  "intent_id",           limit: 4,                     null: false
    t.boolean  "active",                            default: false
    t.integer  "db_id",               limit: 4
    t.integer  "other_db_id",         limit: 4
    t.string   "type",                limit: 255,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "params",              limit: 65535
    t.string   "logo_url",            limit: 255
  end

  add_index "search_merchants", ["db_id"], name: "index_search_merchants_on_db_id", using: :btree
  add_index "search_merchants", ["intent_id"], name: "index_search_merchants_on_intent_id", using: :btree

  create_table "search_pj_commissions", force: :cascade do |t|
    t.string   "commission_id",             limit: 255
    t.integer  "pj_merchant_id",            limit: 4
    t.integer  "resulting_balance",         limit: 4
    t.float    "price",                     limit: 24
    t.float    "commission_amount",         limit: 24
    t.integer  "search_intent_id_received", limit: 4
    t.datetime "occurred_at"
    t.text     "params",                    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_categories_vendors", force: :cascade do |t|
    t.integer  "service_category_id", limit: 4
    t.integer  "vendor_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_requests", force: :cascade do |t|
    t.string   "keyword",             limit: 255
    t.integer  "user_id",             limit: 4
    t.text     "presented_link",      limit: 65535
    t.string   "completetion_number", limit: 255
    t.text     "completion_callback", limit: 65535
    t.decimal  "cashback",                          precision: 10, scale: 5
    t.string   "zip",                 limit: 255
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,      null: false
    t.text     "data",       limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sms_alerts", force: :cascade do |t|
    t.string   "from_phone_number",     limit: 255
    t.string   "receiver_phone_number", limit: 255
    t.string   "status",                limit: 255
    t.string   "twilio_uri",            limit: 255
    t.integer  "user_id",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_users", force: :cascade do |t|
    t.string   "uid",              limit: 255
    t.string   "name",             limit: 255
    t.string   "oauth_token",      limit: 255
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "soleo_categories", force: :cascade do |t|
    t.string   "name",           limit: 255,             null: false
    t.integer  "soleo_id",       limit: 4,               null: false
    t.string   "ancestry",       limit: 255
    t.integer  "ancestry_depth", limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "soleo_categories", ["soleo_id", "ancestry_depth"], name: "index_soleo_categories_on_soleo_id_and_ancestry_depth", unique: true, using: :btree

  create_table "storebotdata", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.string   "datakey",    limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "address",       limit: 255
    t.float    "lat",           limit: 24
    t.float    "lng",           limit: 24
    t.integer  "storable_id",   limit: 4
    t.string   "storable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.integer  "answer_how_many_offers",     limit: 4
    t.integer  "answer_edu_level",           limit: 4
    t.integer  "answer_purchase_factor",     limit: 4
    t.integer  "answer_job_num",             limit: 4
    t.integer  "answer_delivery_preference", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_settings", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_stats", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "value",                  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxonomies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "taxons", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "position",         limit: 4
    t.integer  "parent_id",        limit: 4
    t.string   "permalink",        limit: 255
    t.integer  "taxonomy_id",      limit: 4
    t.text     "description",      limit: 65535
    t.string   "meta_title",       limit: 255
    t.text     "meta_description", limit: 65535
    t.string   "meta_keywords",    limit: 255
    t.string   "nested_name",      limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "in_popular_store",               default: false
  end

  create_table "transfer_fees", force: :cascade do |t|
    t.integer  "feeable_id",        limit: 4
    t.string   "feeable_type",      limit: 255
    t.decimal  "amount",                        precision: 8, scale: 2
    t.decimal  "resulting_balance",             precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_agent_logs", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.string   "user_agent",            limit: 255
    t.string   "browser_name",          limit: 255
    t.string   "browser_major_version", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_coupons", force: :cascade do |t|
    t.integer  "advertisable_id",      limit: 4
    t.string   "advertisable_type",    limit: 255
    t.string   "store_website",        limit: 255
    t.string   "offer_type",           limit: 255
    t.string   "code",                 limit: 255
    t.text     "discount_description", limit: 65535
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin_approve"
    t.integer  "user_id",              limit: 4
    t.string   "header",               limit: 255
    t.string   "offer_header",         limit: 255
  end

  create_table "user_favourites", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer  "user_id",              limit: 4
    t.integer  "static_score",         limit: 4
    t.float    "dynamic_score",        limit: 24
    t.string   "change_origin",        limit: 255
    t.text     "change_origin_params", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_service_providers", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "merchant_name",    limit: 255
    t.string   "merchant_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.boolean  "initiated_auction_mail"
    t.boolean  "ended_auction_mail"
    t.boolean  "bid_mail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "post_to_social"
  end

  create_table "user_transactions", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.decimal  "amount",                        precision: 8, scale: 2
    t.decimal  "resulting_balance",             precision: 8, scale: 2
    t.integer  "transactable_id",   limit: 4
    t.string   "transactable_type", limit: 255
    t.decimal  "total_amount",                  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                           limit: 255,                         default: "",    null: false
    t.string   "encrypted_password",              limit: 255,                         default: "",    null: false
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "password_salt",                   limit: 255
    t.string   "confirmation_token",              limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid",                    limit: 255
    t.string   "facebook_token",                  limit: 255
    t.string   "twitter_uid",                     limit: 255
    t.string   "twitter_token",                   limit: 255
    t.string   "twitter_secret",                  limit: 255
    t.string   "google_uid",                      limit: 255
    t.string   "google_token",                    limit: 255
    t.string   "first_name",                      limit: 255
    t.string   "last_name",                       limit: 255
    t.string   "address",                         limit: 255
    t.string   "city",                            limit: 255
    t.string   "zip_code",                        limit: 255
    t.string   "phone",                           limit: 255
    t.string   "sex",                             limit: 255
    t.string   "age_range",                       limit: 255
    t.decimal  "balance",                                     precision: 8, scale: 2
    t.integer  "sign_in_count",                   limit: 4,                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",              limit: 255
    t.string   "last_sign_in_ip",                 limit: 255
    t.integer  "referred_visit_id",               limit: 4
    t.string   "favourite_browser_name",          limit: 255
    t.string   "favourite_browser_major_version", limit: 255
    t.string   "education",                       limit: 255
    t.string   "occupation",                      limit: 255
    t.string   "income_range",                    limit: 255
    t.string   "marital_status",                  limit: 255
    t.string   "family_size",                     limit: 255
    t.boolean  "home_owner"
    t.boolean  "blocked",                                                             default: false
    t.integer  "score",                           limit: 4
    t.string   "state_abbreviation",              limit: 255
    t.boolean  "from_university_landing_page"
    t.boolean  "donate_enabled",                                                      default: true
    t.boolean  "sales_owner",                                                         default: false
    t.string   "sales_name",                      limit: 255
    t.string   "role",                            limit: 255
    t.string   "storepassword",                   limit: 255
    t.string   "user_bot_id",                     limit: 255,                         default: "nil"
    t.string   "current_loc",                     limit: 255
    t.string   "c_lat",                           limit: 255
    t.string   "c_long",                          limit: 255
    t.datetime "updated_location"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendor_funds_grants", force: :cascade do |t|
    t.decimal  "amount",               precision: 8, scale: 2
    t.integer  "vendor_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_keywords", force: :cascade do |t|
    t.integer  "vendor_id",  limit: 4
    t.string   "keyword",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_settings", force: :cascade do |t|
    t.integer  "vendor_id",                 limit: 4
    t.boolean  "recommended_auctions_mail"
    t.boolean  "auction_status_mail"
    t.boolean  "auction_result_mail"
    t.boolean  "contact_info_mail"
    t.boolean  "auto_bid_mail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto_confirm_outcomes"
  end

  create_table "vendor_tracking_events", force: :cascade do |t|
    t.integer  "vendor_id",  limit: 4
    t.integer  "auction_id", limit: 4
    t.string   "event_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_transactions", force: :cascade do |t|
    t.integer  "vendor_id",         limit: 4
    t.decimal  "amount",                        precision: 8, scale: 2
    t.decimal  "resulting_balance",             precision: 8, scale: 2
    t.integer  "transactable_id",   limit: 4
    t.string   "transactable_type", limit: 255
    t.decimal  "total_amount",                  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", force: :cascade do |t|
    t.string   "email",                          limit: 255,                         default: "",    null: false
    t.string   "encrypted_password",             limit: 255,                         default: "",    null: false
    t.string   "reset_password_token",           limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "password_salt",                  limit: 255
    t.string   "confirmation_token",             limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid",                   limit: 255
    t.string   "facebook_token",                 limit: 255
    t.string   "twitter_uid",                    limit: 255
    t.string   "twitter_token",                  limit: 255
    t.string   "twitter_secret",                 limit: 255
    t.string   "google_uid",                     limit: 255
    t.string   "google_token",                   limit: 255
    t.string   "company_name",                   limit: 255
    t.string   "first_name",                     limit: 255
    t.string   "last_name",                      limit: 255
    t.string   "address",                        limit: 255
    t.string   "city",                           limit: 255
    t.string   "zip_code",                       limit: 255
    t.string   "phone",                          limit: 255
    t.string   "website_url",                    limit: 255
    t.decimal  "balance",                                    precision: 8, scale: 2
    t.boolean  "service_provider",                                                   default: false
    t.boolean  "retailer",                                                           default: false
    t.integer  "sign_in_count",                  limit: 4,                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",             limit: 255
    t.string   "last_sign_in_ip",                limit: 255
    t.datetime "low_funds_notification_sent_at"
    t.datetime "recommendations_sent_at"
    t.string   "review_url",                     limit: 255
    t.boolean  "blocked",                                                            default: false
    t.string   "state_abbreviation",             limit: 255
  end

  add_index "vendors", ["confirmation_token"], name: "index_vendors_on_confirmation_token", unique: true, using: :btree
  add_index "vendors", ["email"], name: "index_vendors_on_email", unique: true, using: :btree
  add_index "vendors", ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true, using: :btree

  create_table "withdrawal_requests", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "paypal_email", limit: 255
    t.integer  "amount",       limit: 4
    t.integer  "user_balance", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.float    "lat",        limit: 24
    t.float    "lng",        limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zip_codes", ["code"], name: "index_zip_codes_on_code", unique: true, using: :btree

  add_foreign_key "favorite_merchants", "users"
  add_foreign_key "hp_store_product_categories", "hp_stores"
  add_foreign_key "hp_store_product_categories", "product_categories"
  add_foreign_key "items", "purchase_histories"
  add_foreign_key "loyalty_program_coupons", "loyalty_programs"
  add_foreign_key "loyalty_program_offer_images", "loyalty_program_offers"
  add_foreign_key "loyalty_program_offer_images", "loyalty_programs"
  add_foreign_key "personal_offers", "loyalty_programs"
end
