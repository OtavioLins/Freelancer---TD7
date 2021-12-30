# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    full_name { 'Otávio Augusto da Silva Lins' }
    social_name { 'Otávio Lins' }
    educational_background { 'Formado em Matemática' }
    description { 'Profissional em mudança de carreira, buscando uma primeira oportunidade' }
    prior_experience { 'Em computação, nenhuma' }
    birth_date { '19/08/1997' }
    professional
    occupation_area
  end
end
