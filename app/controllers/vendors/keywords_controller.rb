class Vendors::KeywordsController < ApplicationController
  
  def index
    @keywords = current_vendor.keywords.search(params[:search]).
      paginate(:page=>params[:page], :per_page=>100)
    @keyword = VendorKeyword.new
  end
  
  def create
    @keyword = current_vendor.keywords.build(params[:vendor_keyword])
    if @keyword.save
      @keyword = VendorKeyword.new
      @keywords = current_vendor.keywords.search(params[:search]).
        paginate(:page=>params[:page], :per_page=>100)
      @reload_form = true
      redirect_to :action=>:index, :page=>params[:page], :search=>params[:search]
    end
  end 
  
  def destroy
    @keyword = current_vendor.keywords.find(params[:id])
    @keyword.destroy
    @keywords = current_vendor.keywords.search(params[:search]).
      paginate(:page=>params[:page], :per_page=>100)
    render :action=>:index
  end
  
  def destroy_all
    num = VendorKeyword.delete_all(:vendor_id=>current_vendor.id)
    redirect_to keywords_path, :notice => "Successfully cleared all #{num} keywords"
  end
  
  def import_from_adwords_csv
    if params[:report_file].blank? || !params[:report_file].respond_to?(:read)
      redirect_to vendors_keywords_path, :alert=>'Please provide a file'
      return
    end
    
    content = params[:report_file].read
    encoding = CMess::GuessEncoding::Automatic.guess(content)
    if !['UTF-8', 'ASCII'].include?(encoding)
      content = Iconv.iconv('UTF-8//IGNORE', encoding, content)[0] #TODO desn't really convert properly
    end
    
    added_keywords_number, duplicate_keywords_number = 
      VendorKeyword.add_from_adwords_csv_content(content, current_vendor)
    
    if added_keywords_number == false
      redirect_to keywords_path, :alert=>'Unable to import keywords from this file'
      return
    end
    notice = if added_keywords_number > 0
      "Successfully added #{added_keywords_number} keywords"
    else
      "No new keywords added"
    end
    
    notice += ". There were #{duplicate_keywords_number} duplicates" if duplicate_keywords_number > 0
    
    redirect_to keywords_path, :notice=>notice
  end
end