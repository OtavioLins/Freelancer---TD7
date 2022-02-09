module Api
  module V1
    class ApiClientsController < Api::V1::ApiController
      before_action :authorized, only: [:auto_login]

      # REGISTER
      def create
        @api_client = ApiClient.create(api_client_params)
        if @api_client.valid?
          token = encode_token({api_client_id: @api_client.id})
          render json: {api_client: @api_client, token: token}
        else
          render json: {error: "Invalid username or password"}
        end
      end

      # LOGGING IN
      def login
        @api_client = ApiClient.find_by(username: params[:username])

        if @api_client && @api_client.authenticate(params[:password])
          token = encode_token({api_client_id: @api_client.id})
          render json: {api_client: @api_client, token: token}
        else
          render json: {error: "Invalid username or password"}
        end
      end

      def auto_login
        render json: @api_client
      end

      private

      def api_client_params
        params.permit(:username, :password)
      end
    end
  end
end