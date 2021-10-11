class HomeController < ApplicationController
    def index
        redirect_to profiles_path if current_user
    end
end