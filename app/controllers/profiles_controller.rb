class ProfilesController < ApplicationController
    before_action :authenticate_professional!, only: [:create, :edit, :new, :update]

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

    def new
        @profile = Profile.new
        @occupation_areas = OccupationArea.all
    end

    def show
        if current_professional.profile.valid?
            @profile = Profile.find(params[:id])
        else
            redirect_to new_profile_path
        end
    end

    def update
        @profile = Profile.find(params[:id])
        if @profile.update(profile_params) 
            redirect_to @profile
        else
            render new
        end
    end

    private

    def profile_params
        params.require(:profile).permit(:full_name, :description,
                                :social_name, :birth_date, :occupation_area_id, 
                                :educational_background, :prior_experience)
    end
end
