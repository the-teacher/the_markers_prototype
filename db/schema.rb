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

ActiveRecord::Schema.define(version: 20140412091732) do

  create_table "marker_relations", force: true do |t|
    t.integer  "marker_id"
    t.integer  "holder_id"
    t.string   "holder_type"
    t.string   "state",       default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers", force: true do |t|
    t.integer  "markers_context_id"
    t.string   "slug",               default: ""
    t.string   "title",              default: ""
    t.string   "state",              default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers_contexts", force: true do |t|
    t.string   "slug",       default: ""
    t.string   "title",      default: ""
    t.boolean  "public",     default: true
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "title"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title",      default: ""
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
