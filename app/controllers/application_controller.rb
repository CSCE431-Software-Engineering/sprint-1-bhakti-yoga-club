class ApplicationController < ActionController::Base
    # before_action :authenticate_admin!

    def require_admin
        unless current_member&.is_admin?
            flash[:alert] = "You are not authorized to access this page."
            redirect_to root_path
        end
    end
    
    def authenticate_member!
        unless member_signed_in?
            flash[:alert] = "Please sign in to access this page."
            redirect_to root_path
        end
    end

end
