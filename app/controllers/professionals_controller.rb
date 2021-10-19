class ProfessionalsController < ApplicationController
    before_action :authenticate_any, only: %i[feedbacks_received_by_users]
    
    def feedbacks_received_by_users
        @professional = Professional.find(params[:id])
    end

    private

    def authenticate_any
        redirect_to root_path if not (current_user.present? || current_professional.present?)
    end
end