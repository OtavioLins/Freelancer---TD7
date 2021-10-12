class ProjectsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :new]
    before_action :authenticate_professional!, only: [:index]
    before_action :authenticate_any, only: [:show]    
    
    def create
        @project = Project.new(project_params)
        @project.user = current_user
        @project.status = 'open'
        if @project.save
            redirect_to @project
        else
            render :new
        end
    end
    
    def index
        @projects = Project.where(status: [:open])
    end

    def new
        @project = Project.new
    end

    def show
        @project = Project.find(params[:id])
    end

    private

    def authenticate_any
        current_user.present? || current_professional.present?
    end

    def project_params
        params.require(:project).permit(:title, :description, :skills, 
                                        :hour_value, :date_limit, :work_regimen)
    end
end