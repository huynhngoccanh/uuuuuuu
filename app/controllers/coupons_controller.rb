class CouponsController < ApplicationController

 layout "ubitru"


  def index 
    begin
      if !params[:q][:search].blank?
        merchant_find =  Sunspot.search(Merchant)do 
          with(:name_downcase,"#{params[:q][:search].downcase}")
          with(:active_status,true)
        end.results
      end   
      if !merchant_find.blank?
        redirect_to "/merchants/#{merchant_find.last.slug}/coupons"
      else 
        @search_co= Sunspot.search(Coupon) do
          any_of do
           with(:expires_at).greater_than(Date.today)
           with(:expires_at, nil)
           end
           paginate :page => 1, :per_page => 10**9
           if params[:q] && (!params[:q][:search].blank?||  params[:q][:merchants] )
            any do
              fulltext "*#{params[:q][:search]}*"
              fulltext params[:q][:search]
            end
              if params[:q][:merchants]
                params[:q][:search]=params[:q][:merchants]
                with(:merchant_name,params[:q][:merchants])
              end
           else
            redirect_to root_path  
          end
        end.results

        deal_activated(@search_co)

        @search = Sunspot.search(Coupon) do
          any_of do
           with(:expires_at).greater_than(Date.today)
           with(:expires_at, nil)
          end
          paginate(:page => params[:page].blank? ? 1 : params[:page], :per_page => 30)
           facet(:merchant_name,limit: 10**9,:sort => :index) 

                if params[:q] && params[:q][:coupon_type]=="code"
                  without(:code,nil)
                elsif params[:q] && params[:q][:coupon_type]=="deal_activated"  
                  
                  with(:code,nil)
                end

          if params[:q] && !params[:q][:search].blank?
            any do
              fulltext "*#{params[:q][:search]}*"
              fulltext params[:q][:search]
                any_of do
                 with(:expires_at).greater_than(Date.today)
                 with(:expires_at,nil)
                end
            end
            any_of do
             (params[:merchants] || []).each do |merchant|
              with(:merchant_name, merchant)
            end
          # with(:expires_at) if params[:q] && params[:q][:filter]
          end
          end
            if params[:q] && params[:q][:filter] && params[:q][:filter] == "Expiring Soon"
          
              with(:expires_at).greater_than(Date.today)
              order_by(:expires_at, :asc)
            
            elsif params[:q] && params[:q][:filter] && params[:q][:filter] == "Popularity"
              with(:expires_at).greater_than(Date.today)
              order_by(:views, :desc)
            end
            
          # facet(:merchant_name)


          if params[:q][:merchants]
            params[:q][:search]=params[:q][:merchants]
            with(:merchant_name,params[:q][:merchants])
          end
        
        order_by(:created_at,:desc)
        end
        @coupons = @search.results

       if  params[:q][:coupon_type]=="all" || @coupons.blank?
         @merchants = Sunspot.search(Merchant) do
          paginate(:page => params[:page].blank? ? 1 : params[:page], :per_page => 30)
           any do
             fulltext "*#{params[:q][:search]}*"
             fulltext params[:q][:search]
           end
           with(:active_status,true)
         end.results
       end
      end
    rescue
      redirect_to :back ,:notice =>"please try again!"
    end

  end
 
 def deal_activated(coupon)
   @count = 0
   coupon.each do |c|
     if c.code == nil || c.code == ''
       @count +=1
     end  
   end
 end

 def show
    if params[:modal].present?
      @coupon = Coupon.find(params[:id])
      render layout: false
    else
      @taxons = Taxon.where(nested_name: "#{params[:nested_name]}").last.descendants
      @search = params[:nested_name].split('/')[-1]
    end
 end

 def redirect
    @coupon = Coupon.where(id: params[:id]).first
    @views=Coupon.where(id: params[:id]).first.increment(:views, by =+ 1)
    @views_at=Coupon.where(id: params[:id]).first.update(views_updated_at: Date.today)
    @views.save
    @click = @coupon.clicks.build(ip: request.ip)
    @click.save
    if !@click.url.blank?
      redirect_to @click.url
    else
      redirect_to :back
    end
 end
 
end