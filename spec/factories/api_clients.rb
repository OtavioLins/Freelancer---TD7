# frozen_string_literal: true

FactoryBot.define do
  factory :api_client do
    username { 'MyString' }
    password_digest { 'MyString' }
  end
end