# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to profiles_path if current_user
    if current_professional
      if current_professional.profile&.valid?
        redirect_to projects_path
      else
        redirect_to new_profile_path
      end
    end
  end
end
