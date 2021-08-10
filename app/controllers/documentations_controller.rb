class DocumentationsController < ApplicationController
  before_action :set_documentation, only: %i[ show edit update destroy ]

  # POST /documentations or /documentations.json
  def create
    @documentation = Documentation.new(documentation_params)

    respond_to do |format|
      if @documentation.save
        format.html { redirect_to @documentation, notice: "Documentation was successfully created." }
        format.json { render :show, status: :created, location: @documentation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @documentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documentations/1 or /documentations/1.json
  def update
    respond_to do |format|
      if @documentation.update(documentation_params)
        format.html { redirect_to @documentation, notice: "Documentation was successfully updated." }
        format.json { render :show, status: :ok, location: @documentation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @documentation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documentation
      @documentation = Documentation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def documentation_params
      params.require(:documentation).permit(:npc_reference, :abn_number, :insured, :profile_id)
    end
end
