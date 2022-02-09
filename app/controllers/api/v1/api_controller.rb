# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :render_generic_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      ActiveRecord::Base.include_root_in_json = true
      before_action :authorized

      def encode_token(payload)
        JWT.encode(payload, 's3cr3t')
      end

      def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
      end

      def decoded_token
        if auth_header
          token = auth_header.split(' ')[1]
          # header: { 'Authorization': 'Bearer <token>' }
          begin
            JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
          end
        end
      end

      def logged_in_api_client
        if decoded_token
          api_client_id = decoded_token[0]['api_client_id']
          @api_client = ApiClient.find_by(id: api_client_id)
        end
      end

      def logged_in?
        !!logged_in_api_client
      end

      def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
      end

      private

      def render_not_authorized
        render status: :unauthorized, json: { message: 'Há algo errado com sua autenticação.' }
      end

      def render_not_found(_exception)
        render status: :not_found, json: { message: 'Objeto não encontrado' }
      end

      def render_generic_error(_exception)
        render status: :internal_server_error, json: { message: 'Erro geral' }
      end
    end
  end
end
