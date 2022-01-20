module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      def index
        @projects = Project.where(status: :open)
        
        render json: @projects.as_json(
          except: %i[created_at updated_at user_id project_applications_id user_feedbacks_id],
          include: { user: { only: %i[email] } }
        )
      end
    end
  end
end