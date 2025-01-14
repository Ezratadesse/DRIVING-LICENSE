class StudentsApplicationsController < ApplicationController
  before_action :set_application, only: [:edit, :update, :approve, :reject]

  # Action for new form rendering
  def new
    if current_user.students_application
      redirect_to root_path, notice: 'You have already submitted an application.'
    else
      @application = StudentsApplication.new
    end
  end

  # Action for form submission
  def create
    @application = current_user.build_students_application(application_params)
    if @application.save
      redirect_to root_path, notice: 'Application submitted successfully.'
    else
      logger.debug "Errors: #{@application.errors.full_messages}"  # Debugging line for errors
      render :new
    end
  end

  # Action to edit an existing application
  def edit
    # This action will render the edit form for an existing application
  end

  # Action to update an application
  def update
    if @application.update(application_params.merge(status: 'pending'))
      redirect_to root_path, notice: 'Application updated successfully.'
    else
      render :edit
    end
  end

  # Action to approve the application
  def approve
    if @application.update(status: 'approved')
      @student = Student.create(
        FirstName: @application.FirstName,
        LastName: @application.LastName,
        phone_number: @application.phone_number,
        user_id: @application.user_id,
        category: @application.category,
        school_id: @application.school_id
      )
      redirect_to school_dashboard_path, notice: 'Application approved and student created successfully.'
    else
      redirect_to school_dashboard_path, alert: 'Failed to approve application.'
    end
  end

  # Action to reject the application
  def reject
    if @application.update(status: 'rejected')
      redirect_to school_dashboard_path, notice: 'Application rejected successfully.'
    else
      redirect_to school_dashboard_path, alert: 'Failed to reject application.'
    end
  end

  private

  # Private method to set application for actions like edit, update, approve, and reject
  def set_application
    @application = StudentsApplication.find(params[:id])
  end

  # Strong parameters for application form submission
  def application_params
    params.require(:students_application).permit(:FirstName, :LastName, :phone_number, :category, :school_id, :middle_name, :gender, :birthday, :address, :city)
  end
end
