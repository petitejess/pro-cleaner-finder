class ApplicationController < ActionController::Base
  # User authentication
  before_action :authenticate_user!

  # Capture query params that are passed to the view
  before_action :set_user_type, :set_profile
  def set_user_type
    if params[:user_type]
      @user_type = params[:user_type]
    end
  end

  def set_profile
    # If user is logged in, get current user's profile
    if user_signed_in? && current_user.profile
      @profile = Profile.find_by(user_id: current_user.id)
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
      new_profile_path(user_type: params[:user][:user_type]) || root_path
    end
  end
end
