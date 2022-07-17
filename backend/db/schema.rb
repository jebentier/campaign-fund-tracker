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

ActiveRecord::Schema[7.0].define(version: 1658065644) do
  create_table "candidates", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "state", limit: 20, null: false
    t.string "country", limit: 20, null: false
    t.string "party_afilliation", limit: 100, default: "Unknown"
    t.string "fec_foriegn_key", limit: 50, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "data_source_id", limit: 8, null: false
    t.index ["data_source_id"], name: "candidates_on_data_source_id"
  end

  create_table "committees", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "state", limit: 20, null: false
    t.string "country", limit: 20, null: false
    t.string "entity_type", limit: 100, default: "Unknown", null: false
    t.string "fec_foriegn_key", limit: 50, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "data_source_id", limit: 8, null: false
    t.index ["data_source_id"], name: "committees_on_data_source_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.float "amount", null: false
    t.date "donated_on", null: false
    t.integer "destination_id", limit: 8, null: false
    t.string "destination_type", limit: 255, null: false
    t.integer "source_id", limit: 8, null: false
    t.string "source_type", limit: 255, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "data_source_id", limit: 8, null: false
    t.index ["data_source_id"], name: "contributions_on_data_source_id"
    t.index ["destination_type", "destination_id"], name: "on_destination_type_and_destination_id"
    t.index ["source_type", "source_id"], name: "on_source_type_and_source_id"
  end

  create_table "data_sources", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "promo", limit: 255, null: false
    t.string "logo", limit: 1024, null: false
    t.string "url", limit: 1024, null: false
    t.text "metadata", default: "{}", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "operating_expenses", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "fec_foriegn_key", limit: 50, null: false
    t.string "state", limit: 20, null: false
    t.string "country", limit: 20, null: false
    t.float "amount", null: false
    t.integer "candidate_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "data_source_id", limit: 8, null: false
    t.index ["candidate_id"], name: "operating_expenses_on_candidate_id"
    t.index ["data_source_id"], name: "operating_expenses_on_data_source_id"
  end

  add_foreign_key "operating_expenses", "candidates"
end
