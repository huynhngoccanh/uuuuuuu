class BestBuy
  include HTTParty
  base_uri 'http://api.remix.bestbuy.com/v1'
  default_params :apiKey => 'egce9q79rp4w2jckavt4e8tz'

  PER_PAGE = 100

  def self.categories page=1
    params = {
      :pageSize => PER_PAGE,
      :page=>page
    }
    self.get("/categories", {:query => params})
  end

  # def self.product id
  #   params = {
  #     :method=>'getProduct',
  #     :productId => id,
  #     :descriptions => '1',
  #     :resourceTypes=> 'all'
  #   }
  #   self.get("", {:query => params})
  # end

  def self.all_with_images page=1, category_id='abcat0502000,pcmcat209400050001'
    params = {
      :pageSize => PER_PAGE,
      :page=>page,
      :show=>'sku,name,image,largeImage,upc,largeFrontImage',
      :sort=> "salesRankMediumTerm.asc"
    }

    where_params = []
    where_params << "categoryPath.id%20in(#{category_id})"
    # where_params << 'releaseDate%3E=2012-01-01'
    # where_params << '(image=*%7ClargeImage=*)'
    where_params << '(largeFrontImage=*)'
    # where_params << '(mediumImage=*)'

    self.get("/products(#{where_params.join('&')})", {:query => params})
  end
end