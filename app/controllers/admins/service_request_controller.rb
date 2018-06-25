class Admins::ServiceRequestController < Admins::ApplicationController
# require 'rails/all'

  def index
    if params[:search]
    	@service_requests = Sunspot.search(ServiceRequest) do 
    		any do
    			fulltext "*#{params[:search]}*"
          paginate(:page => params[:page] || 1, :per_page => params[:per_page] ? params[:per_page] : 50)
          order_by(:created_at,:desc)
    		end
    	end.results
    else	
      @service_requests = Sunspot.search(ServiceRequest) do
        paginate(:page => params[:page] || 1, :per_page => params[:per_page] ? params[:per_page] : 50)
        order_by(:created_at,:desc)
      end.results
    end
  end

  def click
  	if params[:search]
    	@clicks = Sunspot.search(Click) do 
    		any do
    			fulltext "*#{params[:search]}*"
          paginate(:page => params[:page] || 1, :per_page => params[:per_page] ? params[:per_page] : 50)
          order_by(:created_at,:desc)
        end
    	end.results
    else	
    	@clicks = Sunspot.search(Click) do
        paginate(:page => params[:page] || 1, :per_page => params[:per_page] ? params[:per_page] : 50)
        order_by(:created_at,:desc)
      end.results
    end
  end


  def download_csv_file
    report_download_csv_file(params[:start_date],params[:end_date])
  end

  def report_download_csv_file(start_date,end_date)
    start_date = Date.strptime(start_date, "%m/%d/%Y")
    end_date  =  Date.strptime(end_date, "%m/%d/%Y")

    if params[:csv] == 'click'
      header = 'Search ID *Req, Click for, Email , URL, Cashback ,  Date'
      file_name = "Clicks_report#{Date.today}.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        Click.where("DATE(created_at) >= ? AND DATE(created_at) <= ? ", start_date, end_date).each do |click|
        csv_value = click.id, click.resource ? click.advertiser.try(:name) : "", click.user.try(:email),click.url, click.cashback_amount.to_f, click.created_at.strftime("%B-%d-%Y  %T")
          writer << csv_value.map(&:inspect).join(', ')
          writer << "\n"
        end
      end

    else
      header = 'Search ID *Req, Keyword, Email , Presented Link, Completetion Number , Completion Callback, Cashback, Zipcode , Date'
      file_name = "service_requests_report#{Date.today}.csv"
      File.open(file_name, "w") do |writer|
        writer << header
        writer << "\n"
        ServiceRequest.where("DATE(created_at) >= ? AND DATE(created_at) <= ? ", start_date, end_date).each do |service_request|
        csv_value = service_request.id, service_request.keyword, service_request.user.try(:email),service_request.presented_link, service_request.completetion_number, service_request.completion_callback,service_request.cashback.to_f,service_request.zip.to_i,service_request.created_at.strftime("%B-%d-%Y  %T")
          writer << csv_value.map(&:inspect).join(', ')
          writer << "\n"
        end
      end      
    end        
        send_file(file_name)
      # NotifyUser.send_orders_csv_to_admin(file_name).deliver
  end  
end