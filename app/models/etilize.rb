class Etilize
  include HTTParty
  base_uri 'http://ws.spexlive.net/service/rest/catalog'
  default_params :appId => '225580', :locale=>'en_us', :catalog=>'na'

  PER_PAGE = 50

  def self.categories
    params = {
      :method=>'getCategories'
    }
    self.get("", {:query => params})
  end

  def self.search query=nil, page=1
    params = {
      :method=>'search',
      :resourceTypes=> 'all',
    }
    params[:keywordFilter] = query unless query.blank?
    self.get("", {:query => params})
  end

  def self.product id
    params = {
      :method=>'getProduct',
      :productId => id,
      :descriptions => '1',
      :resourceTypes=> 'all'
    }
    self.get("", {:query => params})
  end

  def self.all_with_images page=1
    params = {
      :method=>'search',
      :pageSize=>PER_PAGE,
      :descriptions => '1',
      :resourceTypes=> 'all',
      :pageNo=>page
    }
    self.get("", {:query => params})['SearchResult']
  end
end