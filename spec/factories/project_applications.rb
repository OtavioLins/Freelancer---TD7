# frozen_string_literal: true

FactoryBot.define do
  factory :project_application do
    motivation { 'Achei o projeto bem legal e desafiador' }
    expected_conclusion { '1 mês' }
    weekly_hours { 10 }
    expected_payment { 100 }
    project
    professional { create(:professional, complete_profile: true) }
    situation { :analysis }

    trait :rejected do
      situation { :rejected }
      reject_message { 'Não atendeu os requisitos' }
    end
  end
end
