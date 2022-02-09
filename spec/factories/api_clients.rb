# frozen_string_literal: true

FactoryBot.define do
  factory :api_client do
    sequence(:username) { |n| "TestClient #{n}" }
    password { 'password' }
  end
end
