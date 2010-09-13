# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100615201312) do

  create_table "addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "shipping_price"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip"
  end

  create_table "asset_categories", :force => true do |t|
    t.string   "name"
    t.boolean  "required"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "uuid",              :limit => 36
    t.string   "image_location"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_category_id"
  end

  create_table "checkout_transactions", :force => true do |t|
    t.integer  "checkout_id"
    t.string   "cc_number"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cvv_code"
    t.string   "cvv_message"
    t.string   "avs_result_code"
    t.string   "avs_postal_match"
    t.string   "avs_street_match"
    t.string   "avs_message"
    t.string   "response_code"
    t.string   "response_reason_code"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "transaction"
    t.string   "remote_ip"
  end

  create_table "checkouts", :force => true do |t|
    t.string   "gift_to"
    t.string   "gift_from"
    t.string   "gift_message"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
    t.integer  "user_id"
    t.integer  "nameframe_id"
    t.string   "order_number"
    t.float    "total"
    t.float    "tax"
    t.string   "card_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "shipping_cost"
    t.string   "shipping_type"
    t.string   "authorization"
    t.string   "transaction"
    t.integer  "status"
    t.string   "email"
    t.float    "nameframe_cost"
    t.integer  "archived"
  end

  create_table "emails", :force => true do |t|
    t.string   "method"
    t.string   "from",            :limit => 128
    t.text     "to"
    t.text     "cc"
    t.text     "bcc"
    t.string   "reply_to",        :limit => 128
    t.string   "subject",         :limit => 128
    t.binary   "content"
    t.string   "content_type",    :limit => 64
    t.string   "encoding",        :limit => 64
    t.string   "message_id",      :limit => 64
    t.boolean  "in_progress",                    :default => false, :null => false
    t.boolean  "sent",                           :default => false, :null => false
    t.integer  "attempts",                       :default => 0,     :null => false
    t.string   "last_error",      :limit => 128
    t.integer  "priority",                       :default => 10,    :null => false
    t.datetime "last_attempt_at"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "font_types", :force => true do |t|
    t.string   "name"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "kerning"
    t.float    "letter_width"
    t.decimal  "height_factor", :precision => 10, :scale => 9
  end

  create_table "frame_matt_permissions", :force => true do |t|
    t.integer  "frame_id"
    t.integer  "bottom_matt_id"
    t.integer  "top_matt_id"
    t.boolean  "allowed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frames", :force => true do |t|
    t.string   "uuid",          :limit => 36
    t.string   "name"
    t.string   "file_name"
    t.integer  "top"
    t.integer  "bottom"
    t.integer  "left"
    t.integer  "right"
    t.integer  "top_large"
    t.integer  "bottom_large"
    t.integer  "left_large"
    t.integer  "right_large"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "example_image"
  end

  create_table "free_nameframe_codes", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "discount"
    t.integer  "users_quantity"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "marketing_answers", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matts", :force => true do |t|
    t.string   "uuid"
    t.string   "image"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "core_image"
  end

  create_table "nameframe_props", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "nameframe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "flag"
    t.integer  "asset_category_id"
    t.decimal  "cost",              :precision => 8, :scale => 2
  end

  create_table "nameframes", :force => true do |t|
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image_name"
    t.integer  "frame_id"
    t.integer  "top_matt_id"
    t.integer  "bottom_matt_id"
    t.integer  "top_left_ornament_id"
    t.integer  "top_right_ornament_id"
    t.integer  "bottom_left_ornament_id"
    t.integer  "bottom_right_ornament_id"
    t.integer  "font_id"
    t.string   "selected_text"
    t.string   "flex_address"
    t.boolean  "without_images"
  end

  create_table "ornaments", :force => true do |t|
    t.string   "name"
    t.string   "displayed_name"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_customizations", :force => true do |t|
    t.integer  "x"
    t.integer  "y"
    t.float    "rotation"
    t.float    "width"
    t.float    "height"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "letter_position"
    t.boolean  "is_mask_stretchable"
    t.float    "stretched_image_height"
    t.float    "stretched_image_width"
  end

  create_table "photos", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "nameframe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",        :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["var"], :name => "index_settings_on_var"

  create_table "site_contents", :force => true do |t|
    t.integer  "section_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "publication_date"
    t.string   "owner"
    t.string   "link"
    t.string   "filename"
    t.string   "content_type"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "tiny_mce_photos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "name"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "role_id"
    t.integer  "state",                                   :default => 1
    t.string   "token"
  end

end
