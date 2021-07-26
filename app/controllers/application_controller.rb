class ApplicationController < ActionController::Base
  # Capture query params that are passed to the view
  before_action :set_user_type
  def set_user_type
    @user_type = params[:user_type]
  end

  # Make after_sign_in method redirection
  def after_sign_in_path_for(current_user)
    # if user is customer and have profile, take to root path
    if current_user.profile
      if (params[:user][:user_type] == "customer")
        root_path
      else
        # jobs_path
        root_path
      end
    else
      # pass the user type when creating the new profile
      new_profile_path(user_type: params[:user][:user_type]) || root_path
    end
  end
end
