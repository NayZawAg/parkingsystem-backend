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

ActiveRecord::Schema.define(version: 2024_04_08_054955) do

  create_table "cameras", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.string "name", limit: 255, null: false
    t.boolean "in_flg", null: false
    t.boolean "out_flg", null: false
    t.string "dbx_folder_name", limit: 255, null: false
    t.datetime "dbx_acquired_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "dbx_cursor"
    t.index ["location_id"], name: "index_cameras_on_location_id"
  end

  create_table "chatbot_data", force: :cascade do |t|
    t.datetime "conversation_at", null: false
    t.string "user_id", limit: 255, null: false
    t.string "conversation_id", limit: 255, null: false
    t.string "message", limit: 255
    t.string "button", limit: 255, null: false
    t.string "question_category_one", limit: 255, null: false
    t.string "question_category_two", limit: 255, null: false
    t.string "question_category_three", limit: 255, null: false
    t.boolean "reply", null: false
    t.string "language", limit: 10, null: false
    t.string "area", limit: 255, null: false
    t.string "country", limit: 255, null: false
    t.string "residential_area", limit: 255, null: false
    t.string "user_interface", limit: 255, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "facilities_events", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "slug", limit: 255, null: false
    t.decimal "scale", precision: 3, scale: 1
    t.string "name", limit: 255, null: false
    t.string "address", limit: 255
    t.string "opening_hours", limit: 255
    t.string "phone_number", limit: 255
    t.string "available_payment", limit: 255
    t.string "offical_url", limit: 255
    t.decimal "lat", precision: 10, scale: 7
    t.decimal "lng", precision: 10, scale: 7
    t.string "image"
    t.integer "disabled_flag", default: 0
    t.integer "icon_revert_flag", default: 0
    t.string "gtag_event_name", limit: 255
    t.integer "display_flag", default: 1
    t.string "outline", limit: 255
    t.integer "facility_event_type", default: 1
    t.integer "display_order", default: 0
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "holiday"
    t.integer "facilitiy_event_number", default: 0, null: false
    t.string "gtag_event_card_name", limit: 255
    t.index ["client_id"], name: "index_facilities_events_on_client_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", limit: 255, null: false
    t.string "address", limit: 255
    t.decimal "lat", precision: 10, scale: 7
    t.decimal "lng", precision: 10, scale: 7
    t.string "image"
    t.integer "capacity"
    t.time "start_time", precision: 6
    t.time "end_time", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "disabled_flag", default: false, null: false
    t.integer "camera_flag", default: 1
    t.integer "crowd_level_display", default: 1
    t.integer "icon_revert_flag", default: 0
    t.string "gtag_event_name"
    t.integer "display_flag", default: 1
    t.string "related_facilities_events"
    t.integer "display_order"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.decimal "in_parking_coefficient", precision: 10, scale: 3
    t.integer "capacity_calculation", default: 0
    t.string "notes", limit: 255
    t.time "opening_time", precision: 6
    t.time "closing_time", precision: 6
    t.index ["client_id"], name: "index_locations_on_client_id"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type", limit: 255
    t.string "content", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "parking_resets", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.decimal "total_in_count", precision: 13, scale: 3
    t.decimal "reset_in_count", precision: 13, scale: 3
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "created_by"
    t.bigint "updated_by"
    t.index ["location_id"], name: "index_parking_resets_on_location_id"
  end

  create_table "parking_summaries", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "location_id", null: false
    t.date "date", null: false
    t.time "time", precision: 6, null: false
    t.integer "day_type", default: 0, null: false
    t.integer "in_total", default: 0, null: false
    t.integer "out_total", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id", "location_id", "date", "time"], name: "index_parking_summaries_on_client_id_and_location_id_and_date_and_time"
    t.index ["client_id", "location_id", "day_type"], name: "index_parking_summaries_on_client_id_and_location_id_and_day_type"
    t.index ["client_id"], name: "index_parking_summaries_on_client_id"
    t.index ["location_id"], name: "index_parking_summaries_on_location_id"
  end

  create_table "parking_videos", force: :cascade do |t|
    t.bigint "camera_id", null: false
    t.string "path", null: false
    t.datetime "captured_time", null: false
    t.boolean "analyzed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["analyzed"], name: "index_parking_videos_on_analyzed"
    t.index ["camera_id"], name: "index_parking_videos_on_camera_id"
    t.index ["captured_time"], name: "index_parking_videos_on_captured_time"
  end

  create_table "parkings", force: :cascade do |t|
    t.bigint "camera_id", null: false
    t.boolean "in_out_flg", null: false
    t.datetime "parking_time", null: false
    t.string "car_area", limit: 255
    t.string "car_number", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["camera_id", "in_out_flg", "parking_time"], name: "index_parkings_on_camera_id_and_in_out_flg_and_parking_time"
    t.index ["camera_id"], name: "index_parkings_on_camera_id"
  end

  create_table "user_authorities", force: :cascade do |t|
    t.bigint "facilities_event_id"
    t.bigint "location_id"
    t.bigint "user_id", null: false
    t.string "authority", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["facilities_event_id"], name: "index_user_authorities_on_facilities_event_id"
    t.index ["location_id"], name: "index_user_authorities_on_location_id"
    t.index ["user_id"], name: "index_user_authorities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "username", limit: 255, null: false
    t.string "password_digest", limit: 255, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "use_agree_flag", default: false, null: false
    t.integer "user_type", default: 0, null: false
    t.index ["client_id"], name: "index_users_on_client_id"
  end

  add_foreign_key "cameras", "locations"
  add_foreign_key "facilities_events", "clients"
  add_foreign_key "locations", "clients"
  add_foreign_key "logs", "users"
  add_foreign_key "parking_resets", "locations"
  add_foreign_key "parking_summaries", "clients"
  add_foreign_key "parking_summaries", "locations"
  add_foreign_key "parking_videos", "cameras"
  add_foreign_key "parkings", "cameras"
  add_foreign_key "user_authorities", "facilities_events"
  add_foreign_key "user_authorities", "locations"
  add_foreign_key "user_authorities", "users"
  add_foreign_key "users", "clients"
end
