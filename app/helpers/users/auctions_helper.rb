module Users::AuctionsHelper
  def duration_options
    [
      ['1 day', 1],
      ['2 days', 2],
      ['3 days', 3],
      ['4 days', 4],
      ['5 day', 5],
      ['1 week', 7],
      ['2 weeks', 14],
    ]
  end
  
  def vendors_count_options
    (1..10).to_a
  end
  
  
  def order_url param, type
    dir = :ASC
    if instance_variable_get("@#{type}_order").to_sym == param.to_sym
      dir = instance_variable_get("@#{type}_dir").to_sym == :ASC ? :DESC : :ASC
    end

    # table rendered in a popup - needed another action in url
    if params[:controller] == "vendors/auctions" && params[:action] == "show" && type == :user
      params[:action] = "user"
    end

    url_for(params.merge({:"#{type}_order" => param, :"#{type}_dir"=>dir, :"#{type}_page"=>nil}))
  end
  
  def check_order param, type
    ''
    if instance_variable_get("@#{type}_order").to_sym == param.to_sym
      'active' + if instance_variable_get("@#{type}_dir").to_sym == :DESC 
        ' up' 
      else
        ''
      end
    end
  end
end
