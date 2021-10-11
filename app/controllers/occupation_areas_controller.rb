class OccupationAreasController < ApplicationController
    before_action :authenticate_user!, only: [:show]

    def show
        @occupation_area = OccupationArea.find(params[:id])
        @profiles = @occupation_area.profiles.all
    end
end