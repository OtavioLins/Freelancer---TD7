class UserFeedbacksController < ApplicationController
    
    def create
        @user_feedback = UserFeedback.new(user_feedback_params)
        @user_feedback.professional = Professional.find(params[:professional_id])
        @user_feedback.user = current_user
        @user_feedback.project = Project.find(params[:project_id])
        if @user_feedback.save
            redirect_to @user_feedback.professional.profile
        else
            render :new
        end
    end
    
    def new
        @user_feedback = UserFeedback.new
        @professional = Professional.find(params[:professional_id])
        @project = Project.find(params[:project_id])
    end

    private
    
    def user_feedback_params
        params.require(:user_feedback).permit(:grade, :comment)
    end
end
