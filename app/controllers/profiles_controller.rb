class ProfilesController < ApplicationController
    def create
        @occupation_areas = OccupationArea.all
        @profile = Profile.new(params.require(:profile).permit(:full_name, :description,
            :social_name, :birth_date, :occupation_area_id, :educational_background, 
            :prior_experience))
        @profile.professional = current_professional
        if @profile.save
            redirect_to @profile
        else
            render :new
        end
    end

    def new
        @profile = Profile.new
        @occupation_areas = OccupationArea.all
    end

    def show
        @profile = Profile.find(params[:id])
    end
end