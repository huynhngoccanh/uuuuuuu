module Vendors::AuctionsHelper
  def table_columns type
    table_columns = {
      :bid          =>[:name, :max_vendors, :vendor_bid, :end_time, :category],
      :recommended  =>[:name, :max_vendors, :budget, :end_time, :category],
      :latest       =>[:name, :max_vendors, :budget, :end_time, :category],
      :all_unfinished =>[:name, :max_vendors, :budget, :end_time, :category],
      :product_unfinished =>[:name, :max_vendors, :budget, :end_time, :category],
      :service_unfinished =>[:name, :max_vendors, :budget, :end_time, :category],
      :user         =>[:name, :max_vendors, :budget, :end_time, :category],
      :finished     =>[:name, :vendor_won, :vendor_bid, :end_time, :category],
      :saved        =>[:name, :max_vendors, :budget, :end_time, :category],
      :won          =>[:name, :status, :vendor_bid, :end_time, :category],
    }
    table_columns[type]
  end
  
  def table_cell_html auction, column
    td_content = if column == :name
      link_to auction.name, auction
      
    elsif column == :vendor_bid
      bid_index = auction.bids.index{|b| b.vendor_id==current_vendor.id}
      td_cls = 'warn tip' if bid_index && bid_index+1 > auction.max_vendors.to_i
      val = format_currency(auction.vendor_bid)
      if auction.vendor_max_bid.to_i != auction.vendor_bid.to_i
        val + " (#{format_currency(auction.vendor_max_bid)})" 
      else
        val
      end
      
    elsif column == :end_time
      if auction.status == 'active' && auction.end_time < Time.now
        'processing winners...'
      else
        auction.end_time < Time.now ? format_datetime(auction.end_time) : seconds_to_days_and_time((auction.end_time - Time.now).to_i, false)
      end
      
    elsif column == :category
      (auction.service_category && auction.service_category.name) || (auction.product_category && auction.product_category.name)
      
    elsif column == :vendor_won
      if auction.end_time < Time.now
        if auction.status == 'active'
          'processing ...'
        else
          content_tag(:span, :class=>!auction.vendor_won.zero? ? 'info-green' : 'info-red') do
            !auction.vendor_won.zero? ? 'WON' : 'DID NOT WIN'
          end
        end
      else
        'auction still active..'
      end
      
      
    elsif column == :status
      td_cls = 'tip'
      text = auction.status_text_for_vendor(current_vendor)
      td_cls += ' warn' if text == Auction::CONFIRMATION_NEEDED_TEXT
      text
      
    else
      
      auction.send(column).to_s
    end
    
    #center align
    if [:max_vendors, :budget, :result, :vendor_bid].include? column
      td_cls = td_cls.blank? ? 'ctr' : "#{td_cls} ctr"
    end
    
    content_tag(:td, :class=> td_cls) do
      td_content
    end
  end
  
  def auction_attribute auction, attribute
    if ["created_at", "end_time"].include? attribute
      auction.send(attribute).strftime('%m/%d/%Y %R')
    elsif attribute == "desired_time_range"
      if auction.desired_time_to.blank?
        auction.desired_time.nil? ? nil : auction.desired_time.strftime('%m/%d/%Y')
      else
        "#{auction.desired_time.strftime('%m/%d/%Y')} - #{auction.desired_time_to.strftime('%m/%d/%Y')}"
      end
    elsif attribute == "contact_time_range"
      val = if auction.contact_time.blank?
        'any day'
      else
        if auction.contact_time_to.blank?
          auction.contact_time.strftime '%m/%d/%Y'
        else
          "#{auction.contact_time.strftime('%m/%d/%Y')} - #{auction.contact_time_to.strftime('%m/%d/%Y')}"
        end
      end
      unless auction.contact_time_of_day.blank?
        val += " , in the #{auction.contact_time_of_day}"
      end
      val
    elsif attribute == "category"
      (auction.service_category && auction.service_category.name) || (auction.product_category && auction.product_category.name)
    elsif attribute == "winning_bids_count"
      auction.winning_bids.length
    elsif attribute.match(/^user\./)
      auction.user.send(attribute.gsub(/^user\./,''))
    else
      auction.send(attribute).to_s
    end
  end
  
  def table_column_html column, type
    labels = {
      :name => 'Auction name',
      :max_vendors => 'Slot number',
      :budget => 'Budget',
      :vendor_bid => 'Your bid',
      :end_time => 'Time left (Ended at)',
      :category => 'Category',
      :vendor_won => 'Result',
      :status => 'Outcome Status'
    }
    
    if column == :end_time
      if [:recommended, :latest, :bid, :finished, :won, :all_unfinished, :product_unfinished , :service_unfinished].include?(type)
        label = 'Time left' if [:recommended, :latest, :bid, :all_unfinished, :product_unfinished , :service_unfinished].include?(type)
        label = 'Ended at' if [:finished, :won].include?(type)
      else
        label = labels[column]
      end
    else
      label = labels[column]
    end
    
    content_tag(:th, :class=>check_order(column, type)) do
      link_to order_url(column, type) do
        content_tag(:span, label)
      end
    end
  end
end