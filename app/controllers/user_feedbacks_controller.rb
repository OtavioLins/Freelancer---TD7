# frozen_string_literal: true

class UserFeedbacksController < ApplicationController
  before_action :authenticate_user!, only: %i[create new]

  def create
    authenticate_current_user(Project.find(params[:project_id]))
    @user_feedback = UserFeedback.new(user_feedback_params)
    @user_feedback.professional = Professional.find(params[:professional_id])
    @user_feedback.user = current_user
    @user_feedback.project = Project.find(params[:project_id])
    if @user_feedback.save
      redirect_to @user_feedback.professional.profile
    else
      @professional = @user_feedback.professional
      @project = @user_feedback.project
      render :new
    end
  end

  def new
    @project = Project.find(params[:project_id])
    authenticate_current_user(@project)
    @user_feedback = UserFeedback.new
    @professional = Professional.find(params[:professional_id])
  end

  private

  def authenticate_current_user(project)
    if current_user && current_user != project.user
      redirect_to profiles_path, alert: 'Você não tem permissão para realizar essa ação'
    end
  end

  def user_feedback_params
    params.require(:user_feedback).permit(:grade, :comment)
  end
end
