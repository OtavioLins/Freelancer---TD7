# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      def index
        render :json => Project.where(status: :open)
      end
    end
  end
end
