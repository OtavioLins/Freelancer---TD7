# frozen_string_literal: true

FactoryBot.define do
  factory :professional do
    sequence(:email) { |n| "freelancer#{n}@professional.com" }
    password { '123123123' }

    transient do
      complete_profile { false }
    end

    after :create do |professional, evaluator|
      create(:profile, professional: professional) if evaluator.complete_profile
    end
  end
end
