class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        if current_professional and (current_professional.profile.nil? or current_professional.profile.invalid?)
            stored_location_for(resource) || new_profile_path
        else 
            stored_location_for(resource) || root_path
        end
    end
end
