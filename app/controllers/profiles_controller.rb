# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_professional!, only: %i[create edit new update]
  before_action :authenticate_user!, only: %i[index]
  before_action :authenticate_any, only: %i[show]

  def create
    @occupation_areas = OccupationArea.all
    @profile = Profile.new(profile_params)
    @profile.professional = current_professional
    if @profile.save
      redirect_to @profile,
                  notice: 'Perfil criado com sucesso! Agora você pode ter acesso a diversas partes de nossa plataforma'
    else
      render :new
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    authenticate_current_professional(@profile)
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
        @average = @profile.professional.average_grade
        @projects = @profile.professional.finished_and_accepted_projects
      else
        redirect_to new_profile_path
      end
    elsif current_user
      @profile = Profile.find(params[:id])
      @average = @profile.professional.average_grade
      @projects = @profile.professional.finished_and_accepted_projects
    end
  end

  def update
    @profile = Profile.find(params[:id])
    authenticate_current_professional(@profile)
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'Perfil atualizado com sucesso!'
    else
      @occupation_areas = OccupationArea.all
      render :edit
    end
  end

  private

  def authenticate_current_professional(profile)
    if current_professional && current_professional != profile.professional
      redirect_to projects_path, alert: 'Você não tem permissão para realizar essa ação'
    end
  end

  def profile_params
    params.require(:profile).permit(:full_name, :description,
                                    :social_name, :birth_date, :occupation_area_id,
                                    :educational_background, :prior_experience)
  end
end
