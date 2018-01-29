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

ActiveRecord::Schema.define(version: 20180129033346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.string   "uuid"
    t.integer  "calendar_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "completed",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["calendar_id"], name: "index_appointments_on_calendar_id", using: :btree
  end

  create_table "calendars", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
  end

  create_table "time_slot_types", force: :cascade do |t|
    t.string  "uuid"
    t.string  "name"
    t.integer "slot_size"
  end

  create_table "time_slots", force: :cascade do |t|
    t.string   "uuid"
    t.integer  "calendar_id"
    t.integer  "appointment_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "time_slot_type_id"
    t.index ["appointment_id"], name: "index_time_slots_on_appointment_id", using: :btree
    t.index ["calendar_id"], name: "index_time_slots_on_calendar_id", using: :btree
    t.index ["time_slot_type_id"], name: "index_time_slots_on_time_slot_type_id", using: :btree
  end

end
