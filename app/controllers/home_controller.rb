class HomeController < ApplicationController
    before_action :authenticate_user!, only: [:students, :application_status]
  
    def index
    end
  
    def students
    end
  
    def application_status
      if current_user.present?
        @application_status = current_user.students_application&.status
        if @application_status.nil?
          flash[:alert] = "No application found for the current user."
        end
      else
        redirect_to login_path, alert: "Please log in to view your application status."
      end
    end
  end
  