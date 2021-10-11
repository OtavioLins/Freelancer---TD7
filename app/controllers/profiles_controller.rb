class ProfilesController < ApplicationController
    before_action :authenticate_professional!, only: [:create, :edit, :new, :update]
    before_action :authenticate_user!, only: [:index]
    before_action :authenticate_any, only: [:show]
    def create
        @occupation_areas = OccupationArea.all
        @profile = Profile.new(profile_params)
        @profile.professional = current_professional
        if @profile.save
            redirect_to @profile
        else
            render :new
        end
    end

    def edit
        @profile = Profile.find(params[:id])
        @occupation_areas = OccupationArea.all
    end

    def index
        @profiles = Profile.all
        @occupation_areas = OccupationArea.all
    end

    def new
        @profile = Profile.new
        @occupation_areas = OccupationArea.all
    end

    def show
        if current_professional
            if current_professional.profile.valid?
                @profile = Profile.find(params[:id])
            else
                redirect_to new_profile_path
            end
        elsif current_user
            @profile = Profile.find(params[:id])
        end
    end

    def update
        @profile = Profile.find(params[:id])
        if @profile.update(profile_params) 
            redirect_to @profile
        else
            @occupation_areas = OccupationArea.all
            render :edit
        end
    end

    private

    def profile_params
        params.require(:profile).permit(:full_name, :description,
                                :social_name, :birth_date, :occupation_area_id, 
                                :educational_background, :prior_experience)
    end

    def authenticate_any
        current_user.present? || current_professional.present?
    end
end
