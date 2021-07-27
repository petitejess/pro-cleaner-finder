class ApplicationController < ActionController::Base
  # User authentication
  before_action :authenticate_user!

  # Capture query params that are passed to the view
  before_action :set_user_type, :get_profile
  def set_user_type
    if params[:user_type]
      @user_type = params[:user_type]
    end
  end

  def get_profile
    # If user is logged in, get current user's profile
    if current_user
      @profile = Profile.find_by(user_id: current_user.id)
    end
  end

  # Make after_sign_in method redirection
  def after_sign_in_path_for(current_user)
    # If user is customer and have profile, take to root path
    if current_user.profile
      if (params[:user][:user_type] == "customer")
        root_path
      else
        # jobs_path
        root_path
      end
    else
      # Pass the user type when creating the new profile
      new_profile_path(user_type: params[:user][:user_type]) || root_path
    end
  end
end
