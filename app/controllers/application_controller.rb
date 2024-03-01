class ApplicationController < ActionController::Base

    before_action :set_admin_view

    # Function that determines whether the logged in member is an admin
    def require_admin
        unless current_member&.is_admin?
            flash[:alert] = "You are not authorized to access this page."
            redirect_to root_path
        end
    end
    
    # Function that determines if a member is signed in
    def authenticate_member!
        unless member_signed_in?
            flash[:alert] = "Please sign in to access this page."
            redirect_to root_path
        end
    end

    def set_admin_view
        if current_member && current_member.is_admin?
            session[:admin_view] = true
        else
            session[:admin_view] = false
        end
        @admin_mode = session[:admin_view]
        Rails.logger.info "Current value of admin_view session variable: #{@admin_mode}"
    end

    def toggle_admin_view
        session[:admin_view] = !session[:admin_view]
        @admin_mode = session[:admin_view]
        Rails.logger.info "Current value of admin_view session variable: #{@admin_mode}"
        redirect_back(fallback_location: root_path)
    end

end
