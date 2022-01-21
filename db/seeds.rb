# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  user = User.create!(email: 'otavio@user.com', password: '123131')
  project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                              description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                              skills: 'Conhecimento em Rails, Web Design e segurança',
                              date_limit: 20.days.from_now, work_regimen: :remote,
                              hour_value: 300, user: user, status: :open)
  project2 = Project.create!(title: 'Sistema de aluguel de carros',
                              description: 'Projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
                              skills: 'Conhecimento em Rails, Web Design e segurança',
                              date_limit: 10.days.from_now, work_regimen: :remote,
                              hour_value: 300, user: user, status: :open)
  project3 = Project.create!(title: 'Sistema de aluguel de iates',
                              description: 'Projeto que visa criar uma aplicação para oferecer iater alugáveis em todo o litoral de São Paulo',
                              skills: 'Conhecimento em Rails, Web Design e segurança',
                              date_limit: 3.days.from_now, work_regimen: :remote,
                              hour_value: 300, user: user, status: :finished)