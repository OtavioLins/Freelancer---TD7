# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_211_018_202_049) do
  create_table 'occupation_areas', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'professionals', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_professionals_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_professionals_on_reset_password_token', unique: true
  end

  create_table 'profiles', force: :cascade do |t|
    t.string 'full_name'
    t.string 'social_name'
    t.string 'educational_background'
    t.string 'description'
    t.string 'prior_experience'
    t.date 'birth_date'
    t.integer 'professional_id', null: false
    t.integer 'occupation_area_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['occupation_area_id'], name: 'index_profiles_on_occupation_area_id'
    t.index ['professional_id'], name: 'index_profiles_on_professional_id'
  end

  create_table 'project_applications', force: :cascade do |t|
    t.string 'motivation'
    t.string 'expected_conclusion'
    t.integer 'weekly_hours'
    t.decimal 'expected_payment'
    t.integer 'project_id', null: false
    t.integer 'professional_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'situation', default: 0
    t.string 'reject_message'
    t.string 'cancelation_message'
    t.date 'acceptance_date'
    t.index ['professional_id'], name: 'index_project_applications_on_professional_id'
    t.index ['project_id'], name: 'index_project_applications_on_project_id'
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'title'
    t.string 'description'
    t.string 'skills'
    t.decimal 'hour_value'
    t.date 'date_limit'
    t.integer 'work_regimen', default: 0
    t.integer 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'status', default: 0
    t.index ['user_id'], name: 'index_projects_on_user_id'
  end

  create_table 'user_feedbacks', force: :cascade do |t|
    t.integer 'grade'
    t.string 'comment'
    t.integer 'professional_id', null: false
    t.integer 'project_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'user_id', null: false
    t.index ['professional_id'], name: 'index_user_feedbacks_on_professional_id'
    t.index ['project_id'], name: 'index_user_feedbacks_on_project_id'
    t.index ['user_id'], name: 'index_user_feedbacks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'profiles', 'occupation_areas'
  add_foreign_key 'profiles', 'professionals'
  add_foreign_key 'project_applications', 'professionals'
  add_foreign_key 'project_applications', 'projects'
  add_foreign_key 'projects', 'users'
  add_foreign_key 'user_feedbacks', 'professionals'
  add_foreign_key 'user_feedbacks', 'projects'
  add_foreign_key 'user_feedbacks', 'users'
end
