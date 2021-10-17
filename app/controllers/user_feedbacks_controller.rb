class UserFeedbacksController < ApplicationController
    
    def create
        @user_feedback = UserFeedback.new(user_feedback_params)
        @user_feedback.professional = Professional.find(params[:professional_id])
    end
    
    def new
        @user_feedback = UserFeedback.new
        @professional = Professional.find(params[:professional_id])
    end

    private
    
    def user_feedback_params
        params.require(:user_feedback).permit(:grade, :comment)
    end
end
