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

ActiveRecord::Schema[8.1].define(version: 2026_03_12_015755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url", null: false
    t.text "long_description", null: false
    t.string "name", null: false
    t.integer "rating", null: false
    t.string "short_description", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_trips_on_lower_name", unique: true
    t.index ["name"], name: "index_trips_on_name"
    t.index ["name"], name: "index_trips_on_name_trigram", opclass: :gin_trgm_ops, using: :gin
    t.index ["rating"], name: "index_trips_on_rating"
  end
end
