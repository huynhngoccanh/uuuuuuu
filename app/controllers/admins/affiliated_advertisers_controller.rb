class Admins::AffiliatedAdvertisersController < Admins::ApplicationController

  def index

  end

  def set_source_category_to_copy_mappings
    session[:copy_source_category_id] = params[:copy_source_category_id] if params[:copy_source_category_id].present?
    render :json => params[:copy_source_category_id]
  end

  def copy_mappings_to_current_category
    if session[:copy_source_category_id].blank? || params[:current_category_id].blank?
      render :json => false and return
    end
    source = ProductCategory.find(session[:copy_source_category_id])
    target = ProductCategory.find(params[:current_category_id])

    target.cj_advertiser_category_mappings.delete_all
    target.avant_advertiser_category_mappings.delete_all
    target.linkshare_advertiser_category_mappings.delete_all
    target.pj_advertiser_category_mappings.delete_all
    target.ir_advertiser_category_mappings.delete_all

    cj_category_mappings = source.cj_advertiser_category_mappings
    avant_category_mappings = source.avant_advertiser_category_mappings
    linkshare_category_mappings = source.linkshare_advertiser_category_mappings
    pj_category_mappings = source.pj_advertiser_category_mappings
    ir_category_mappings = source.ir_advertiser_category_mappings

    CjAdvertiserCategoryMapping.transaction do
      cj_category_mappings.each do |el|
        new_el = CjAdvertiserCategoryMapping.new el.attributes
        new_el.product_category = target
        new_el.save
      end
    end

    AvantAdvertiserCategoryMapping.transaction do
      avant_category_mappings.each do |el|
        new_el = AvantAdvertiserCategoryMapping.new el.attributes
        new_el.product_category = target
        new_el.save
      end
    end

    LinkshareAdvertiserCategoryMapping.transaction do
      linkshare_category_mappings.each do |el|
        new_el = LinkshareAdvertiserCategoryMapping.new el.attributes
        new_el.product_category = target
        new_el.save
      end
    end

    PjAdvertiserCategoryMapping.transaction do
      pj_category_mappings.each do |el|
        new_el = PjAdvertiserCategoryMapping.new el.attributes
        new_el.product_category = target
        new_el.save
      end
    end

    IrAdvertiserCategoryMapping.transaction do
      ir_category_mappings.each do |el|
        new_el = IrAdvertiserCategoryMapping.new el.attributes
        new_el.product_category = target
        new_el.save
      end
    end

    render :json => source.id
  end

  def download_user_data
    download_user_data_records 'cj'
  end

  def cj_fetch_coupons_manually
    begin
      CjCoupon.reload_all_coupons
      flash[:notice] = 'Operation completed successfully.'
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_to :action => :index
  end

  def avant_fetch_coupons_manually
    begin
      AvantCoupon.reload_all_coupons
      flash[:notice] = 'Operation completed successfully.'
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_to :action => :index
  end

  def linkshare_fetch_coupons_manually
    begin
      LinkshareCoupon.reload_all_coupons
      flash[:notice] = 'Operation completed successfully.'
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_to :action => :index
  end

  def pj_fetch_coupons_manually
    begin
      PjCoupon.reload_all_coupons
      flash[:notice] = 'Operation completed successfully.'
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_to :action => :index
  end

  def ir_fetch_coupons_manually
    begin
      IrCoupon.reload_all_coupons
      flash[:notice] = 'Operation completed successfully.'
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_to :action => :index
  end

  def cj_advertisers
    send_affiliates_file 'cj'
  end

  def avant_advertisers
    send_affiliates_file 'avant'
  end

  def linkshare_advertisers
    send_affiliates_file 'linkshare'
  end

  def pj_advertisers
    send_affiliates_file 'pj'
  end

  def ir_advertisers
    send_affiliates_file 'ir'
  end

  def cj_coupons
    send_coupons_file 'cj'
  end

  def cj_auto_downloaded_coupons
    send_coupons_file 'cj', true
  end

  def avant_coupons
    send_coupons_file 'avant'
  end

  def avant_auto_downloaded_coupons
    send_coupons_file 'avant', true
  end

  def linkshare_coupons
    send_coupons_file 'linkshare'
  end

  def linkshare_auto_downloaded_coupons
    send_coupons_file 'linkshare', true
  end

  def pj_coupons
    send_coupons_file 'pj'
  end

  def ir_coupons
    send_coupons_file 'ir'
  end

  def pj_auto_downloaded_coupons
    send_coupons_file 'pj', true
  end

  def ir_auto_downloaded_coupons
    send_coupons_file 'ir', true
  end

  def cj_coupons_from_csv
    if params[:cj_coupons_csv].blank? || !params[:cj_coupons_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    delete_count = CjCoupon.delete_all(:manually_uploaded => true)
    count = CjCoupon.import_csv params[:cj_coupons_csv].path
    redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Cj Coupons. (deleted previous #{delete_count} coupons)"
  end

  def avant_coupons_from_csv
    if params[:avant_coupons_csv].blank? || !params[:avant_coupons_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    delete_count = AvantCoupon.delete_all(:manually_uploaded => true)
    count = AvantCoupon.import_csv params[:avant_coupons_csv].path
    redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Avant Coupons. (deleted previous #{delete_count} coupons)"
  end

  def linkshare_coupons_from_csv
    if params[:linkshare_coupons_csv].blank? || !params[:linkshare_coupons_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    delete_count = LinkshareCoupon.delete_all(:manually_uploaded => true)
    count = LinkshareCoupon.import_csv params[:linkshare_coupons_csv].path
    redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Linkshare Coupons. (deleted previous #{delete_count} coupons)"
  end

  def pj_coupons_from_csv
    if params[:pj_coupons_csv].blank? || !params[:pj_coupons_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    delete_count = PjCoupon.delete_all(:manually_uploaded => true)
    count = PjCoupon.import_csv params[:pj_coupons_csv].path
    redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Pj Coupons. (deleted previous #{delete_count} coupons)"
  end

  def ir_coupons_from_csv
    if params[:ir_coupons_csv].blank? || !params[:ir_coupons_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    delete_count = IrCoupon.delete_all(:manually_uploaded => true)
    count = IrCoupon.import_csv params[:ir_coupons_csv].path
    redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Ir Coupons. (deleted previous #{delete_count} coupons)"
  end

  def affiliates_categories

  end

  def product_category_affiliates
    @product_category = ProductCategory.find(params[:product_category_id])
    load_mappings
  end

  def update_product_category_affiliates
    @product_category = ProductCategory.find(params[:product_category_id])
    @product_category.cj_advertiser_ids = params[:product_category][:cj_advertiser_ids]
    @product_category.avant_advertiser_ids = params[:product_category][:avant_advertiser_ids]
    @product_category.linkshare_advertiser_ids = params[:product_category][:linkshare_advertiser_ids]
    @product_category.pj_advertiser_ids = params[:product_category][:pj_advertiser_ids]
    @product_category.ir_advertiser_ids = params[:product_category][:ir_advertiser_ids]

    respond_to do |format|
      if @product_category.save
        notice = "Affiliations to category \"#{@product_category.name}\" were successfully updated."
        format.html { redirect_to(:back, :notice => notice) }
        format.js {
          flash.now[:notice] = notice
          render 'application/show_flash'
        }
      else
        alert = "Something went wrong. Please try again or contact support if the problem persists."
        format.html { redirect_to(:back, :alert => alert) }
        format.js {
          flash.now[:alert] = alert
          render 'application/show_flash'
        }
      end
    end
  end

  def add_affiliate_mapping
    type = params[:type]
    @product_category = ProductCategory.find(params[:product_category_id])
    @advertiser = "#{type.capitalize}Advertiser".constantize.find(params[:advertiser_id])
    "#{type.capitalize}AdvertiserCategoryMapping".constantize.create({
        :product_category=>@product_category,
        :"#{type}_advertiser"=>@advertiser
      })
    load_mappings
    render 'product_category_affiliates'
  end

  def remove_affiliate_mapping
     type = params[:type]
     @mapping = "#{type.capitalize}AdvertiserCategoryMapping".constantize.find(params[:id])
     @product_category = @mapping.product_category
     @mapping.destroy
     load_mappings
     render 'product_category_affiliates'
  end

  def toggle_affiliate_mapping_preferred
     type = params[:type]
     @mapping = "#{type.capitalize}AdvertiserCategoryMapping".constantize.find(params[:id])
     @mapping.preferred = !@mapping.preferred
     @mapping.save
     @product_category = @mapping.product_category
     load_mappings
     render 'product_category_affiliates'
  end

  private
  def download_user_data_records type
    respond_to do |format|
      format.csv do
        @auctions = Auction.order('user_id DESC')
        csv_string = CSV.generate do |csv|
          csv << ["User Name", "User Email","Address","City","Zip","Phone","Gender","Age Range","MM Score","Auction Number","Auction Description",
                  "Auction description / Project name", "Category","Desired time of service", "Best contact time","Additional info","Started at","Ended at","Status","Result"]
          @auctions.each do |a|
            purchase_no_string = "Not Purchased"
            unless a.outcome.nil?
              if a.outcome.purchase_made
                purchase_no_string = "Purchased"
              end
            end
            csv << [ a.user.first_name+' '+a.user.last_name, a.user.email,a.user.address, a.user.city, a.user.zip_code, a.user.phone, a.user.sex,a.user.age_range, a.user.score, a.id, a.name,
              get_category(a),get_end_time(a.desired_time), get_end_time(a.contact_time), a.extra_info, a.created_at.strftime("%d/%m/%Y"), get_end_time(a.end_time), a.status, purchase_no_string ]
          end
        end
        send_data csv_string, :filename => "Histroy.csv"
      end
    end
  end

  def send_affiliates_file type
    respond_to do |format|
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << ['Name', 'ID', 'website']
          "#{type.capitalize}Advertiser".constantize.where(:inactive=>[false,nil]).each do |a|
            csv << [a.name, a.advertiser_id, a.advertiser_url]
          end
        end
        send_data csv_string, :filename => "#{type} linked advertisers.csv"
      end
    end
  end

  def send_coupons_file type, auto=false
    respond_to do |format|
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << ['Advertiser', 'Advertiser ID', 'Header', 'Coupon code', 'Description', 'Expiration date']
          coupons = "#{type.capitalize}Coupon".constantize
          coupons = auto ? coupons.where(:manually_uploaded=>[false,nil]) : coupons.where(:manually_uploaded=>1)
          coupons.each do |c|
            csv << [
              c.advertiser_name,
              c.advertiser_id,
              c.header,
              c.code,
              c.description,
              c.expires_at.blank? ? '' : c.expires_at.strftime('%m/%d/%Y'),
            ]
          end
        end
        send_data csv_string, :filename => "#{type} coupons #{auto ? 'from api' : ''}.csv"
      end
    end
  end

  private
  def load_mappings
    @cj_mappings = @product_category.cj_advertiser_category_mappings.
                    order('preferred DESC, cj_advertisers.name ASC').eager_load(:cj_advertiser).
                    where('cj_advertisers.id IS NOT NULL')
    @avant_mappings = @product_category.avant_advertiser_category_mappings.
                    order('preferred DESC, avant_advertisers.name ASC').eager_load(:avant_advertiser).
                    where('avant_advertisers.id IS NOT NULL')
    @linkshare_mappings = @product_category.linkshare_advertiser_category_mappings.
                    order('preferred DESC, linkshare_advertisers.name ASC').eager_load(:linkshare_advertiser).
                    where('linkshare_advertisers.id IS NOT NULL')
    @pj_mappings = @product_category.pj_advertiser_category_mappings.
                    order('preferred DESC, pj_advertisers.name ASC').eager_load(:pj_advertiser).
                    where('pj_advertisers.id IS NOT NULL')
    @ir_mappings = @product_category.ir_advertiser_category_mappings.
                    order('preferred DESC, ir_advertisers.name ASC').eager_load(:ir_advertiser).
                    where('ir_advertisers.id IS NOT NULL')
  end

  def get_end_time(end_time)
    return "" if end_time.nil?
    return end_time.strftime("%d/%m/%Y")
  end

  def get_category(auction)
    return "" if auction.product_category_id.nil?
    return auction.product_category.name
  end

end
