# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "freelancer#{n}@projectowner.com" }
    password { '123123123' }
  end
end
