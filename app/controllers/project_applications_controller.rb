# frozen_string_literal: true

class ProjectApplicationsController < ApplicationController
  before_action :authenticate_professional!, only: %i[cancel cancelation_justification create my_applications]
  before_action :authenticate_user!, only: %i[accept index reject reject_justification]

  def accept
    @project_application = ProjectApplication.find(params[:id])
    authenticate_current_user(@project_application)
    @project_application.acceptance_date = Date.today
    @project_application.accepted!
    redirect_to project_project_applications_path(@project_application.project),
                notice: 'Proposta aceita com sucesso!'
  end

  def cancel
    @project_application = ProjectApplication.find(params[:id])
    authenticate_current_professional(@project_application)
    @project_application.situation = :canceled
    if @project_application.update(project_application_params)
      redirect_to my_applications_path, notice: 'Proposta cancelada com sucesso'
    else
      @project_application.situation = :analysis
      render :cancelation_justification
    end
  end

  def cancelation_justification
    @project_application = ProjectApplication.find(params[:id])
    authenticate_current_professional(@project_application)
    if @project_application.analysis?
      @project_application.canceled!
      redirect_to my_applications_path, notice: 'Proposta cancelada com sucesso'
    end
  end

  def create
    @project_application = ProjectApplication.new(project_application_params)
    @project_application.professional = current_professional
    @project_application.project = Project.find(params[:project_id])
    if @project_application.save
      MailDeliveryJob.perform_later(@project_application.id)
      redirect_to my_applications_path, notice: 'Proposta enviada com sucesso'
    else
      @project = Project.find(params[:project_id])
      render '/projects/show'
    end
  end

  def index
    @project = Project.find(params[:project_id])
    @project_applications = @project.project_applications
  end

  def my_applications
    if current_professional.profile.valid?
      @project_applications = current_professional.project_applications
    else
      redirect_to new_profile_path
    end
  end

  def reject
    @project_application = ProjectApplication.find(params[:id])
    authenticate_current_user(@project_application)
    @project_application.situation = :rejected
    if @project_application.update(project_application_params)
      redirect_to project_project_applications_path(@project_application.project),
                  notice: 'Proposta rejeitada com sucesso'
    else
      @project_application.situation = :analysis
      render :reject_justification
    end
  end

  def reject_justification
    @project_application = ProjectApplication.find(params[:id])
    authenticate_current_user(@project_application)
  end

  private

  def authenticate_current_professional(application)
    if current_professional && current_professional != application.professional
      redirect_to projects_path, alert: 'Você não tem permissão para realizar essa ação'
    end
  end

  def authenticate_current_user(application)
    if current_user && current_user != application.project.user
      redirect_to profiles_path, alert: 'Você não tem permissão para realizar essa ação'
    end
  end

  def project_application_params
    params.require(:project_application).permit(:reject_message, :cancelation_message, :motivation, :weekly_hours,
                                                :expected_conclusion, :expected_payment)
  end
end
