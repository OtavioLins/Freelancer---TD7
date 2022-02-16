# frozen_string_literal: true

require 'rails_helper'

describe 'Projects exportation API' do
  context 'GET /api/v1/projects' do
    it 'should get open projects, their user and the project applications' do
      professional = create(:professional, complete_profile: true)
      client = create(:api_client)
      project1 = create(:project)
      project2 = create(:project)
      project3 = create(:project, status: :finished)
      application1 = create(:project_application, project: project1, professional: professional)
      application2 = create(:project_application, project: project2, professional: professional)
      token = JWT.encode({ api_client_id: client.id }, 's3cr3t')

      get '/api/v1/projects', headers: { 'Authorization': "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      projects = response.parsed_body
      expect(projects.first['title']).to include(project1.title)
      expect(projects.first['user']['email']).to include(project1.user.email)
      expect(projects.first['project_applications'].first['situation']).to include(application1.situation)
      expect(projects.first['project_applications'].first['professional']['email']).to include(professional.email)
      expect(projects.second['title']).to include(project2.title)
      expect(projects.second['user']['email']).to include(project2.user.email)
      expect(projects.second['project_applications'].first['situation']).to include(application2.situation)
      expect(projects.second['project_applications'].first['professional']['email']).to include(professional.email)
      expect(projects.size).to eq(2)
    end

    it 'should not get open projects because the user isnt logged in' do
      client = create(:api_client)
      create(:project)

      get '/api/v1/projects'
      expect(response).to have_http_status(401)
      expect(response.parsed_body['message']).to include('Please log in')
    end
  end
end
