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

ActiveRecord::Schema.define(version: 20140303221544) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
  end

  create_table "reviews", force: true do |t|
    t.text    "content"
    t.integer "user_id"
    t.integer "video_id"
    t.integer "rating"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_categories", force: true do |t|
    t.integer  "video_id"
    t.integer  "category_id"
    t.datetime "crated_at"
  end

  create_table "video_ratings", force: true do |t|
    t.integer "user_id"
    t.integer "review_id"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "small_cover"
    t.string   "large_cover"
    t.text     "description"
    t.datetime "created_at"
  end

end
