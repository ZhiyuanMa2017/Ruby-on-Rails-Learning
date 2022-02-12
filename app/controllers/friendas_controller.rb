class FriendasController < ApplicationController
  before_action :set_frienda, only: %i[ show edit update destroy ]

  # GET /friendas or /friendas.json
  def index
    @friendas = Frienda.all
  end

  # GET /friendas/1 or /friendas/1.json
  def show
  end

  # GET /friendas/new
  def new
    @frienda = Frienda.new
  end

  # GET /friendas/1/edit
  def edit
  end

  # POST /friendas or /friendas.json
  def create
    @frienda = Frienda.new(frienda_params)

    respond_to do |format|
      if @frienda.save
        format.html { redirect_to frienda_url(@frienda), notice: "Frienda was successfully created." }
        format.json { render :show, status: :created, location: @frienda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @frienda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friendas/1 or /friendas/1.json
  def update
    respond_to do |format|
      if @frienda.update(frienda_params)
        format.html { redirect_to frienda_url(@frienda), notice: "Frienda was successfully updated." }
        format.json { render :show, status: :ok, location: @frienda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @frienda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendas/1 or /friendas/1.json
  def destroy
    @frienda.destroy

    respond_to do |format|
      format.html { redirect_to friendas_url, notice: "Frienda was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frienda
      @frienda = Frienda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def frienda_params
      params.require(:frienda).permit(:first_name, :last_name, :email, :phone, :twitter)
    end
end
