class Admins::CouponsController < Admins::ApplicationController
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]

  # GET /coupons
  # GET /coupons.json
  def index
    if params[:filter]
      if params[:manually_uploaded].nil?
        @coupons = Coupon.where(coupon_type: "#{params[:filter]}").paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      elsif params[:manually_uploaded] == "true"

        @coupons = Coupon.where(coupon_type: "#{params[:filter]}").paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      elsif params[:manually_uploaded] == "false"
        @coupons = Coupon.where(coupon_type: "#{params[:filter]}").paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      end
    else
      if params[:manually_uploaded].nil?
        @coupons = Coupon.paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      elsif params[:manually_uploaded] == "true"
        @coupons = Coupon.where(manually_uploaded: (params[:manually_uploaded] == "true")).paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      elsif params[:manually_uploaded] == "false"
        @coupons = Coupon.where(manually_uploaded: nil).paginate(:page => params[:page], :per_page => 100).order("created_at desc").includes(:merchant)
      end
    end  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/new
  def new
    @coupon = Coupon.new
  end

  # GET /coupons/1/edit
  def edit

  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(coupon_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to edit_admins_coupon_path(@coupon), notice: 'Coupon was successfully created.' }
        format.json { render json: @coupon, status: :created }
      else
        p "------------------------------"
        p @coupon.errors
        flash.now[:error] = @coupon.errors.full_messages.join(", ")
        format.html { render action: 'new' }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coupons/1
  # PATCH/PUT /coupons/1.json
  def update
    respond_to do |format|
      if @coupon.update(coupon_params.merge({verified_at: Time.now}))
        
        format.html { redirect_to edit_admins_coupon_path(@coupon), notice: 'Coupon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon.destroy
    respond_to do |format|
      format.html { redirect_to admins_coupons_url }
      format.json { head :no_content }
    end
  end

  def download_csv_file_coupon
    if (params[:start_date]&&params[:end_date]).blank?
      flash[:error] = "Please Select related date"
      redirect_to '/admins/coupons?manually_uploaded=true'
    else
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:end_date], "%m/%d/%Y")
      header = 'Coupon Id, Coupon Header, Coupon Code, Merchant, Created On, Exipry On'
      file_name = "coupons_submitted_by_customer#{start_date}_to_#{end_date}.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        Coupon.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND  manually_uploaded = ?", start_date, end_date,true).each do |coupon|
        csv_value = coupon.id, coupon.header, coupon.code, coupon.merchant.try(:name), coupon.created_at, coupon.expires_at
          writer << csv_value.map(&:inspect).join(', ')
          writer << "\n"
        end
      end
         
        send_file(file_name)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coupon_params
      params[:coupon].permit!
    end
end