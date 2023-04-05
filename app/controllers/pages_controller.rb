class PagesController < ApplicationController

    def dashboard
        if logged_in? && current_user.status == "pending"
            redirect_to pending_path
        else
            redirect_to dashboard_path
        end
    end

    def pending
    end

    def admin
        @users = User.all
        if logged_in? && !current_user.isadmin 
            redirect_to dashboard_path
        end
    end

end