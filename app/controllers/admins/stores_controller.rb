class Admins::StoresController < Admins::ApplicationController

  def index
  end

  def avant_stores
    if params[:avant_stores_csv].blank? || !params[:avant_stores_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    filename = params[:avant_stores_csv].original_filename.split(".").first
    advertiser = AvantAdvertiser.where("name LIKE (?)", "%#{filename}%").first
    unless advertiser.blank?
      count = Store.import_stores_from_csv(params[:avant_stores_csv].path, advertiser)
      redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Store Details for #{advertiser.name} affiliate found"
    else
      redirect_to url_for(:action=>'index'), :alert=>'Affiliate not found'
    end
  end

  def ls_stores
    if params[:ls_stores_csv].blank? || !params[:ls_stores_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    filename = params[:ls_stores_csv].original_filename.split(".").first
    advertiser = LinkshareAdvertiser.where("name LIKE (?)", "%#{filename}%").first
    unless advertiser.blank?
      count = Store.import_stores_from_csv(params[:ls_stores_csv].path, advertiser)
      redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Store Details for #{advertiser.name} affiliate found"
    else
      redirect_to url_for(:action=>'index'), :alert=>'Affiliate not found'
    end
  end

  def cj_stores
    if params[:cj_stores_csv].blank? || !params[:cj_stores_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    filename = params[:cj_stores_csv].original_filename.split(".").first
    advertiser = CjAdvertiser.where("name LIKE (?)", "%#{filename}%").first
    unless advertiser.blank?
      count = Store.import_stores_from_csv(params[:cj_stores_csv].path, advertiser)
      redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Store Details for #{advertiser.name} affiliate found"
    else
      redirect_to url_for(:action=>'index'), :alert=>'Affiliate not found'
    end
  end

  def pj_stores
    if params[:pj_stores_csv].blank? || !params[:pj_stores_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    filename = params[:pj_stores_csv].original_filename.split(".").first
    advertiser = PjAdvertiser.where("name LIKE (?)", "%#{filename}%").first
    unless advertiser.blank?
      count = Store.import_stores_from_csv(params[:pj_stores_csv].path, advertiser)
      redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Store Details for #{advertiser.name} affiliate found"
    else
      redirect_to url_for(:action=>'index'), :alert=>'Affiliate not found'
    end
  end

  def ir_stores
    if params[:ir_stores_csv].blank? || !params[:ir_stores_csv].respond_to?(:read)
      redirect_to url_for(:action=>:index), :alert=>'Please provide a file'
      return
    end
    filename = params[:ir_stores_csv].original_filename.split(".").first
    advertiser = IrAdvertiser.where("name LIKE (?)", "%#{filename}%").first
    unless advertiser.blank?
      count = Store.import_stores_from_csv(params[:ir_stores_csv].path, advertiser)
      redirect_to url_for(:action=>'index'), :notice=>"Imported #{count} Store Details for #{advertiser.name} affiliate found"
    else
      redirect_to url_for(:action=>'index'), :alert=>'Affiliate not found'
    end
  end


end
