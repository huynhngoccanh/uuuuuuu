class Admins::MerchantsController < Admins::ApplicationController
  before_action :set_merchant, only: [:show, :edit, :update, :destroy]

  # GET /merchants
  # GET /merchants.json
  def index
    @merchants = Merchant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @merchants }
    end
  end

  # GET /merchants/1
  # GET /merchants/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @merchant }
    end
  end

  # GET /merchants/new
  def new
    @merchant = Merchant.new
  end

  # GET /merchants/1/edit
  def edit
  end

  # POST /merchants
  # POST /merchants.json
  def create
    @merchant = Merchant.new(merchant_params)

    respond_to do |format|
      if @merchant.save
        format.html { redirect_to edit_admins_merchant_path(@merchant), notice: 'Merchant was successfully created.' }
        format.json { render json: @merchant, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /merchants/1
  # PATCH/PUT /merchants/1.json
  def update
    respond_to do |format|
      if @merchant.update(merchant_params)
        format.html { redirect_to edit_admins_merchant_path(@merchant), notice: 'Merchant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1
  # DELETE /merchants/1.json
  def download_csv_file_most_seached_merchants
    if (params[:start_date]&&params[:end_date]).blank?
      header = 'Merchant Id, Merchant Name, Created On, last time Searched'
      file_name = "Most_searched_merchant.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        Merchant.all.order('view_counter desc').each do |merchant|
        csv_value = merchant.id, merchant.try(:name), merchant.created_at
          writer << csv_value.map(&:inspect).join(', ')
          writer << "\n"
        end
      end
        send_file(file_name)
    else
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:end_date], "%m/%d/%Y")
      header = 'Merchant Id, Merchant Name, Created On, last time Searched'
      file_name = "Most_searched_merchant#{start_date}_to_#{end_date}.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        Merchant.where("DATE(created_at) >= ? AND DATE(created_at) <= ?", start_date, end_date).order('view_counter desc').each do |merchant|
        csv_value = merchant.id, merchant.try(:name), merchant.created_at, merchant.updated_at
          writer << csv_value
          writer << "\n"
        end
      end
         
        send_file(file_name)
    end
  end

  def destroy
    @merchant.destroy
    respond_to do |format|
      format.html { redirect_to admins_merchants_url }
      format.json { head :no_content }
    end
  end


  def loyalty_programs_users
    @programs= LoyaltyProgramsUser.all
  end
  def download_csv_file_loyalty_programs
    if (params[:start_date]&&params[:end_date]).blank?
      header = 'Programs Id, User Id, Merchant, Status, Account Number, Points'
      file_name = "loyalty_programs_users_report.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        LoyaltyProgramsUser.all.each do |program|
        csv_value = program.id, program.account_id, program.loyalty_program.name, program.status.humanize, program.account_number, program.points
          writer << csv_value.map(&:inspect).join(', ')
          writer << "\n"
        end
      end
        send_file(file_name)
    else
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:end_date], "%m/%d/%Y")
      header = 'Merchant Id, Merchant Name, Created On, last time Searched'
      file_name = "Most_searched_merchant#{start_date}_to_#{end_date}.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        Merchant.where("DATE(created_at) >= ? AND DATE(created_at) <= ?", start_date, end_date).order('view_counter desc').each do |merchant|
        csv_value = merchant.id, merchant.try(:name), merchant.created_at, merchant.updated_at
          writer << csv_value
          writer << "\n"
        end
      end
         
        send_file(file_name)
    end
  end


  def download_csv_commission_deatils
    header = ' Merchant, Cashback Amount, Sale Amount, Advertiser'
    file_name = "loyalty_programs_users_report.csv"
    File.open(file_name, "w") do |writer|
      writer << header
      writer << "\n"
      [Search::PjCommission.all, Search::LinkshareCommission.all].flatten.each do |merchant|
      csv_value = merchant.try(:params).try(:fetch, 'program_name'),merchant.commission_amount, merchant.price, merchant.model_name.name
        writer << csv_value.map(&:inspect).join(', ')
        writer << "\n"
      end
    end
      send_file(file_name)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def merchant_params
      params[:merchant].permit!
    end
end