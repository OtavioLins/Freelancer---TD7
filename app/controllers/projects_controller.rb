class ProjectsController < ApplicationController
    before_action :authenticate_user!, only: %i[create new my_projects]
    before_action :authenticate_professional!, only: %i[index]
    before_action :authenticate_any, only: %i[show]
    before_action :check_status!, only: %i[index my_projects show]
    
    def closing
        @project = Project.find(params[:id])
        authenticate_current_user(@project)
        @project.closed!
        @project.project_applications.where(situation: :analysis).each do |application|
            application.reject_message = 'Esse projeto está agora fechado para propostas'
            application.rejected!
        end
        redirect_to my_projects_projects_path
    end
    
    def create
        @project = Project.new(project_params)
        @project.user = current_user
        @project.status = 'open'
        if @project.save
            redirect_to @project, notice: 'Projeto criado com sucesso'
        else
            render :new
        end
    end
    
    def early_closing
        @project = Project.find(params[:id])
        authenticate_current_user(@project)
    end

    def finish
        @project = Project.find(params[:id])
        authenticate_current_user(@project)
        @project.finished!
        redirect_to @project
    end

    def finishing_confirmation
        @project = Project.find(params[:id])
        authenticate_current_user(@project)
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

    def search
        @projects = Project.where("title LIKE ? OR description LIKE ?", "%#{params[:text]}%", "%#{params[:text]}%").where(status: :open)
    end

    def show
        @project = Project.find(params[:id])
        if current_professional
            redirect_to new_profile_path if current_professional.profile.invalid?
            if @project.closed? or @project.finished?
                @project_application = ProjectApplication.find_by(professional: current_professional, project: @project)
                if @project_application and (not @project_application.accepted?)
                    redirect_to my_applications_path, alert: 'Você não tem mais acesso a esse projeto'
                end
            end
        end        
        @project_application = ProjectApplication.new
    end

    def team
        @project = Project.find(params[:id])
        @project_applications = ProjectApplication.where(project_id: (params[:id]), situation: :accepted)
    end

    private

    def authenticate_any
        current_user.present? || current_professional.present?
    end

    def authenticate_current_user(project)
        if current_user && current_user != project.user
            redirect_to profiles_path, alert: 'Você não tem permissão para realizar essa ação'
        end
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