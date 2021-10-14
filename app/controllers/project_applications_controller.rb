class ProjectApplicationsController < ApplicationController
    before_action :authenticate_professional!, only: [:create, :my_applications]

    def create
        @project_application = ProjectApplication.new(project_application_params)
        @project_application.professional = current_professional
        @project_application.project = Project.find(params[:project_id])
        if @project_application.save
            redirect_to my_applications_project_applications_path, notice: 'Proposta enviada com sucesso'
        else
            @project = Project.find(params[:project_id])
            render '/projects/show'
        end
    end

    def index
        @project = Project.find(params[:project_id])
        @project_applications = ProjectApplication.where(params[:project_id])
    end

    def my_applications
        if current_professional.profile.valid?
            @project_applications = current_professional.project_applications
        else
            redirect_to new_profile_path
        end
    end

    private

    def project_application_params
        params.require(:project_application).permit(:motivation, :weekly_hours, :expected_conclusion, :expected_payment)
    end
end