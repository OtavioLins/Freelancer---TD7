# frozen_string_literal: true

FactoryBot.define do
  factory :professional do
    sequence(:email) { |n| "freelancer#{n}@professional.com" }
    password { '123123123' }
  end
end
