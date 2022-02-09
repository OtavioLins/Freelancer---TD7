# frozen_string_literal: true

require 'rails_helper'

describe 'API Clients' do
  context 'POST /api/v1/login' do
    it 'should login successfully and receive a token' do
      client = ApiClient.create!(username: 'testclient', password: '123321')

      post '/api/v1/login',
           params: {
             username: client.username,
             password: client.password
           }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      client_info = parsed_body
      expect(client_info[:api_client][:api_client][:username]).to include('testclient')
      expect(client_info[:api_client][:api_client][:token]).not_to eq('nil')
    end

    it 'should not login successfully because account not created' do
      post '/api/v1/login',
           params: {
             username: 'testclient',
             password: '123456'
           }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      client_info = parsed_body
      expect(client_info[:error]).to include('Invalid username or password')
    end

    it 'should not login successfully because of wrong password' do
      client = ApiClient.create!(username: 'testclient', password: '123321')

      post '/api/v1/login',
           params: {
             username: 'testclient',
             password: '123456'
           }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      client_info = parsed_body
      expect(client_info[:error]).to include('Invalid username or password')
    end

    it 'should not login successfully because of wrong username' do
      client = ApiClient.create!(username: 'testclient', password: '123321')

      post '/api/v1/login',
           params: {
             username: 'testclienat',
             password: client.password
           }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      client_info = parsed_body
      expect(client_info[:error]).to include('Invalid username or password')
    end
  end
  context 'POST /api/v1/api_clients' do
    it 'should create an api client successfully' do
      post '/api/v1/api_clients',
           params: {
             username: 'otavioslins',
             password: '123456789'
           }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      client_info = parsed_body
      expect(client_info[:api_client][:api_client][:username]).to include('otavioslins')
      expect(client_info[:api_client][:api_client][:token]).not_to eq('nil')
    end
  end
end
