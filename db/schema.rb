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

ActiveRecord::Schema.define(version: 20180325070921) do

  create_table "devices", force: :cascade do |t|
    t.string "serial_number"
    t.string "model"
    t.datetime "last_contact"
    t.datetime "last_activation"
    t.string "firmware_version"
  end

  create_table "devices_groups", id: false, force: :cascade do |t|
    t.integer "device_id"
    t.integer "group_id"
    t.index ["device_id"], name: "index_devices_groups_on_device_id"
    t.index ["group_id"], name: "index_devices_groups_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "type"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "email"
    t.integer "group_id"
    t.string "password_digest"
    t.index ["group_id"], name: "index_users_on_group_id"
  end

end
