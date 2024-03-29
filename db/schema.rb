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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130209163115) do

  create_table "histories", :force => true do |t|
    t.string   "email"
    t.integer  "screenshot_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "histories", ["screenshot_id"], :name => "index_histories_on_screenshot_id"

  create_table "results", :force => true do |t|
    t.boolean  "status"
    t.text     "message"
    t.integer  "scenario_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "results", ["scenario_id"], :name => "index_results_on_scenario_id"

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "screenshots", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "delivered"
    t.string   "file"
    t.string   "token"
    t.boolean  "error"
  end

  create_table "sizes", :force => true do |t|
    t.integer  "height"
    t.integer  "width"
    t.integer  "screenshot_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "file"
  end

  add_index "sizes", ["screenshot_id"], :name => "index_sizes_on_screenshot_id"

  create_table "steps", :force => true do |t|
    t.string   "action"
    t.string   "what"
    t.string   "with"
    t.integer  "x"
    t.integer  "y"
    t.integer  "scenario_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "steps", ["scenario_id"], :name => "index_steps_on_scenario_id"

end
