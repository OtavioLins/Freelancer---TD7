# frozen_string_literal: true

require 'rails_helper'

describe 'Projects exportation API' do
  context 'GET /api/v1/projects' do
    it 'should get open projects' do
      client = ApiClient.create!(username: 'testclient', password: '123321')
      user = User.create!(email: 'otavio@user.com', password: '123131')
      @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                  description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 20.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :open)
      @project2 = Project.create!(title: 'Sistema de aluguel de carros',
                                  description: 'Projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 10.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :open)
      @project3 = Project.create!(title: 'Sistema de aluguel de iates',
                                  description: 'Projeto que visa criar uma aplicação para oferecer iater alugáveis em todo o litoral de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 3.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :finished)

      post '/api/v1/login',
           params: {
             username: client.username,
             password: client.password
           }

      get '/api/v1/projects', headers: { 'Authorization': "Bearer #{parsed_body[:token]}" }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      projects = response.parsed_body
      expect(projects.first['project']['title']).to include('Sistema de aluguel de imóveis')
      expect(projects.second['project']['title']).to include('Sistema de aluguel de carros')
      expect(projects.size).to eq(2)
    end

    it 'should not get open projects because the user isnt logged in' do
      client = ApiClient.create!(username: 'testclient', password: '123321')
      user = User.create!(email: 'otavio@user.com', password: '123131')
      @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                  description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 20.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :open)

      get '/api/v1/projects'
      expect(response).to have_http_status(401)
      expect(response.parsed_body['message']).to include('Please log in')
    end
  end
end
