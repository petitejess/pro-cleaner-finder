class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action :set_user_type, :set_states, :set_postcodes, :set_suburbs, :set_property, :set_documentation

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @profile.user_type = @user_type
    @profile.build_documentation
  end

  # GET /profiles/1/edit
  def edit
    @user_type = @profile.user_type
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)
    
    # Capture query params being passed
    @suburb_id = params[:suburb_id]

    # Assigned current user id
    @profile.user_id = current_user.id

    respond_to do |format|
      if @profile.save
          # Else if params Cleaner, redirect to jobs page after creating a profile
        if params[:profile][:user_type] == "pro"
          format.html { redirect_to root_path, notice: "Profile was successfully created." }
        else
          # If params Customer, redirect to to root path after creating a profile
          format.html { redirect_to root_path, notice: "Profile was successfully created." }
        end

        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_user_type
      # Capture query params being passed
      @user_type = params[:user_type] ? params[:user_type] : "customer"
    end

    def set_states
      @states = State.all
    end

    def set_postcodes
      @postcodes = Postcode.all
    end

    def set_suburbs
      @suburbs = Suburb.all
    end

    def set_documentation
      @documentation = Documentation.new
    end

    def set_property
      @documentation = Property.new
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone, :user_type, :user_id, :image, documentation_attributes: [:npc_reference, :abn_number, :insured], property_attributes: [:property_type, :storey, :bed, :bath, :street_address, :suburb_id, :description])
    end
end
