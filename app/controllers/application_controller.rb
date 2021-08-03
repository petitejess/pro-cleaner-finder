class ApplicationController < ActionController::Base
  # User authentication
  before_action :authenticate_user!
  before_action :set_user_type, :set_profile

  def set_user_type
    if params[:user_type]
      @user_type = params[:user_type]
      # Keep user_type upon sign up, in case user decides to navigate away to homepage and back to creating profile
      session[:user_type] = params[:user_type]
    else
      # If user indeed navigates away and wants to continue creating profie, use the user_type kept in session
      @user_type = session[:user_type]
    end
  end

  def set_profile
    # If user is logged in, set current user's profile
    if user_signed_in? && current_user.profile
      @profile = current_user.profile
    end
  end

  # Make after_sign_in method redirection
  def after_sign_in_path_for(current_user)
    # If user is Customer and have profile, take to root path
    if current_user.profile
      if (current_user.profile.user_type == "customer")
        root_path
      else
        # If user is Cleaner and have profile, take to jobs path
        jobs_path
      end
    else
      # Pass the user type when creating the new profile
      if params[:user_type]
        new_profile_path(user_type: params[:user_type]) || root_path
      end
    end
  end
end
