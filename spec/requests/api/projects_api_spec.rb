# frozen_string_literal: true

require 'rails_helper'

describe 'Projects exportation API' do
  context 'GET /api/v1/projects' do
    it 'should get open projects' do
      client = create(:api_client)
      project1 = create(:project)
      project2 = create(:project)
      project3 = create(:project, status: :finished)
      token = JWT.encode({ api_client_id: client.id }, 's3cr3t')

      get '/api/v1/projects', headers: { 'Authorization': "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      projects = response.parsed_body
      expect(projects.first['project']['title']).to include(project1.title)
      expect(projects.second['project']['title']).to include(project2.title)
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
