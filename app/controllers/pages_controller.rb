class PagesController < ApplicationController

    def dashboard
        if logged_in? && current_user.status == "pending"
            redirect_to pending_path
        end
    end

    def pending
    end

    def admin
        if logged_in? && !current_user.isadmin 
            redirect_to dashboard_path
        end
    end

end