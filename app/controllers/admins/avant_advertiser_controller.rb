class Admins::AvantAdvertiserController < Admins::ApplicationController

before_action :set_advertiser, only: [:show, :edit, :update, :destroy]

  # GET /merchants
  # GET /merchants.json
  def index
    
  end

  # GET /merchants/1
  # GET /merchants/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advertiser }
    end
  end

  
  # GET /merchants/1/edit
  def edit

  end

  # PATCH/PUT /merchants/1
  # PATCH/PUT /merchants/1.json
  def update
    respond_to do |format|
      if @advertiser.update(advertiser_params)
        format.html { redirect_to edit_admins_avant_advertiser_path(@advertiser), notice: 'advertiser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @advertiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /merchants/1
  # # DELETE /merchants/1.json
  def destroy
    @advertiser.destroy
    respond_to do |format|
      
      format.html { redirect_to admins_avant_advertiser_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertiser
      @advertiser = AvantAdvertiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertiser_params
       
      params[:avant_advertiser].permit!      
    end
end