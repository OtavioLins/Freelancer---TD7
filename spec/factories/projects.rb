# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Sistema de aluguel #{n}" }
    description { 'Projeto que visa criar uma aplicação do 0 para gerenciar um sistema de aluguéis' }
    skills { 'Conhecimento em Rails, Web Design e segurança' }
    date_limit { 20.days.from_now }
    work_regimen { :remote }
    hour_value { 100 }
    status { :open }
    user
  end
end
