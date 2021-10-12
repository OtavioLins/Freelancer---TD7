class ProjectsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :new, :my_projects]
    before_action :authenticate_professional!, only: [:index]
    before_action :authenticate_any, only: [:show]
    before_action :check_status!, only: [:index, :my_projects, :show]

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
        @projects = Project.where(status: :open)
    end

    def my_projects
        @projects = current_user.projects
    end

    def new
        @project = Project.new
    end

    def show
        @project = Project.find(params[:id])
        @project_application = ProjectApplication.new
    end

    private

    def authenticate_any
        current_user.present? || current_professional.present?
    end

    def check_status!
        Project.where(status: :open).each do |p|
            p.closed! if p.date_limit < Time.now
        end
    end

    def project_params
        params.require(:project).permit(:title, :description, :skills, 
                                        :hour_value, :date_limit, :work_regimen)
    end
end