class ProjectApplicationsController < ApplicationController
    before_action :authenticate_professional!, only: [:create]

    def create
        @project_application = ProjectApplication.new(project_application_params)
        @project_application.professional = current_professional
        @project_application.project = Project.find(params[:project_id])
        if @project_application.save
        else
        end
    end

    private

    def project_application_params
        params.require(:project_application).permit(:motivation, :weekly_hours, :expected_conclusion, :expected_payment)
    end
end