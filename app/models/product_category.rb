class ProductCategory < ActiveRecord::Base
  has_ancestry

  has_many :auctions, :dependent=>:restrict_with_error
  has_many :hp_store_product_categories
  has_many :hp_stores, through: :hp_store_product_categories
  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :vendors
  has_many :avant_advertiser_category_mappings
  has_many :avant_advertisers, :through=>:avant_advertiser_category_mappings
  has_many :avant_preferred_advertisers, -> {where({:"avant_advertiser_category_mappings.preferred"=>true})}, :source=>:avant_advertiser, 
           :through=>:avant_advertiser_category_mappings
  has_many :avant_non_preferred_advertisers, 
    -> {where(:"avant_advertiser_category_mappings.preferred"=>[false,nil])}, :source=>:avant_advertiser, 
           :through=>:avant_advertiser_category_mappings   
  has_many :cj_advertiser_category_mappings
  has_many :cj_advertisers, :through=>:cj_advertiser_category_mappings
  has_many :cj_preferred_advertisers, -> {where(:"cj_advertiser_category_mappings.preferred"=>true)},
           :source=>:cj_advertiser, 
           :through=>:cj_advertiser_category_mappings
  has_many :cj_non_preferred_advertisers, -> {where(:"cj_advertiser_category_mappings.preferred" => [false,nil])}, 
           :source=>:cj_advertiser, :through=>:cj_advertiser_category_mappings
  has_many :linkshare_advertiser_category_mappings
  has_many :linkshare_advertisers, :through=>:linkshare_advertiser_category_mappings
  has_many :cj_non_preferred_advertisers, -> {where(:"cj_advertiser_category_mappings.preferred" => [false,nil])}, 
           :source=>:cj_advertiser, :through=>:cj_advertiser_category_mappings
  has_many :linkshare_non_preferred_advertisers, -> {where(:"linkshare_advertiser_category_mappings.preferred" => [false,nil])}, 
           :source=>:linkshare_advertiser, :through=>:linkshare_advertiser_category_mappings
  has_many :pj_advertiser_category_mappings
  has_many :pj_advertisers, :through=>:pj_advertiser_category_mappings
  has_many :pj_preferred_advertisers, -> {where(:"pj_advertiser_category_mappings.preferred"=>true)},
           :source=>:pj_advertiser,
           :through=>:pj_advertiser_category_mappings
  has_many :pj_non_preferred_advertisers, ->{where(:"pj_advertiser_category_mappings.preferred" => [false,nil])},
           :source=>:pj_advertiser,
           :through=>:pj_advertiser_category_mappings
  has_many :ir_advertiser_category_mappings
  has_many :ir_advertisers, :through=>:ir_advertiser_category_mappings
  has_many :ir_preferred_advertisers, -> {where(:"ir_advertiser_category_mappings.preferred"=>true)},
           :source=>:ir_advertiser,
           :through=>:ir_advertiser_category_mappings
  has_many :ir_non_preferred_advertisers,->{where(:"ir_advertiser_category_mappings.preferred" => [false,nil])}, 
           :source=>:ir_advertiser,
           :through=>:ir_advertiser_category_mappings

  validates :name, :presence=>true
  self.per_page = 20

  MPS  =  ["Accessories", "Appliances", "Art & crafts", "Automative",  "Baby", "Beautify & Health", "Books", "Clothing", "Cooking", "Food", "Musical Instruments", "School Supplies", "Shoes", "Sporting Goods", "Sports Apparel", "Ticket & Travel", "Novelty Items"].sort_by{|e| e}
  
  #PCS = ["Accessories", "Airline", "Air Conditioning", "Appliances", "Automotive", "Baby", "Books", "Boots", "Builders", "Cable/Dish TV", "Cameras", "Car Rentals", "Clothng", "Coffee", "Computers", "Cosmetics", "Costumes", "Crafts", "Debt Repair",
  #  "Decor", "Delivery", "Designer", "Dresses", "Electricians", "Electronics", "Fashion", "Flights", "Flowers", "Food", "Furniture", "Games", "Gifts", "Health", "Home", "Hotels", "HVAC", "Insurance", "Internet", "Jewelry",
  #  "Kids", "Laptops", "Mac", "Magazines", "Makeup", "Movies", "Music", "Outdoors", "Party Supplies", "Photo", "Plumbing", "Roofers", "Shoes", "Skin Care", "Software", "Sports", "Supplements", "Tablets", "Tickets", "Tools",
  #  "Toys", "Travel", "TVs", "Weddings"].sort_by{|e| e}

  PCS = ["Accessories", "Airline", "Air Conditioning", "Appliances", "Automotive", "Baby", "Books", "Cameras", "Car Rentals", "Clothng", "Coffee", "Computers", "Cosmetics", "Costumes", "Crafts", "Debt Repair", "Decor", "Delivery", "Discounts", "Dresses","Education", "Electricians", "Electronics", "Fashion", "Flights", "Flowers", "Food", "Furniture", "Games", "Gifts", "Health", "Home", "Hotels", "HVAC", "Insurance", "Internet", "Jewelry","Kids", "Laptops", "Mac", "Magazines", "Makeup", "Movies", "Music", "Outdoors", "Party Supplies","Pets", "Plumbing", "Roofers", "Shoes", "Skin Care", "Software", "Sports", "Supplements", "Tablets", "Tickets", "Tools","Toys", "Travel", "TVs", "Weddings"].sort_by{|e| e}  





  MOST_POPULAR_STORES = {
    'Accessories'=> ['Ebags', 'Sunglasses Hut', 'SUSU Handbag', 'Ray-Ban', 'Oakley', 'Jewelry.com'],
    'Appliances'=> ['Sears', 'AJ Madison', 'Sears Outlet', 'Homeclick', 'Whirlpool'],
    'Art'=> ['Art.com', 'Dollar Tree', 'Sears Outlet', 'Peapod', 'Magic Cabin'],
    'Automotive'=> ['Auto Parts Warehouse', 'Advance Auto Parts', 'Sears Parts Direct', 'Firestone Auto Care', 'The Tire Rack'],
    'Baby' => ['Diapers.com', 'Baby Age', 'Baby Leggings', 'Giggle'],
    'Beautify & Health' => ['Vitamin Shoppe', 'Elizabeth Arden', 'Perfume Worldwide', 'Walgreens', 'Rite-Aid', 'Sephra', 'Drugstore.com', 'Hayneedle'],
    'Books' => ['Booksamillion', 'Book Outlet', 'eCampus', 'eBooks', 'Betterworld Books', 'Textbooks Bookrenter'],
    'Clothing' => ['Tommy Hilfiger', "Levi's", 'Banana Republic', 'Silver Jeans', 'Marmot', 'Nordstrom', 'Beyondtherack', 'Orvis', 'Eastern Mountain Sports', 'REI', 'North by Northwest', 'Salomon', 'Piperlime', 'Athleta', 'Jane', 'Ellie', 'French Toast', 'Bluefly', 'Journeys', 'Life is Good', 'The Limited', 'Nautica'],
    "Cooking" => ['Cooking.com', 'Rachel Ray Store', 'ShopKitchenAid.com', 'Pots and Pans'],
    'School Supplies' => ['Discount School Supplies', 'Staples', 'Office Supply'],
    'Shoes' => ['Shoes.com', 'Famous Footwear', 'DNA Footwear', 'Buy.com', 'PlanetShoes.com'],
    'Sporting Goods' => ["Modell's", 'Road Runner Sports', 'City Sports', 'Soccer.com', 'Lacross.com', 'HockeyMonkey', 'Homerun Monkey', 'Snowboards', 'New Balance', "Joe's", 'Gaiam', 'Football America', 'Softball.com', 'Basketball Express', 'The Sports Authority', 'Footlocker'],
    'Sports Apparel' => ['NFL Shop', 'Nascar', 'The NBA Store', 'NHL', 'Fanatics', 'Fanzz', 'Fathead', 'Team Express', 'Ice Jerseys'],
    'Ticket & Travel' => ['TicketNetwork', 'Ticket Solutions', 'Ticket Spot', 'Priceline', 'Travelocity', 'Hotwire', 'Expedia', 'Hotels', 'Virgin Atlantic', 'Hertz', 'Thrifty']
  }

  # TIRE WILL NOT BE USED -- REMOVING 20-FEB-18-22:03
  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  # # Define the mapping
  # tire.mapping do
  #   indexes :name, :type => 'string'
  #   # ...
  # end  
  def to_indexed_json
    fullname = name
    if ancestry.present? && ancestry.index('/').present?
      fullname = parent.parent.name + ' ' + parent.name + ' ' + name
    elsif ancestry.present?
      fullname = parent.name + ' ' + name
    end
    {:id => id, :name => fullname}.to_json
  end

  def self.relevant_search(s_string)
    s_string = Search::Intent.check_requested_query(s_string)
    # database search
    result = where('name = ?', s_string).first
    if result.nil?
      result = where('name like ?', "%#{s_string}%").first
    end
    # elastic search

    if result.nil?
      # keyword short filter
      search_string = s_string.gsub(/\bmen'?s?\b/i, 'men').gsub(/\bwomen'?s?\b/i, 'women').gsub(/\bboy'?s?\b/i, 'boy').gsub(/\bgirl'?s?\b/i, 'girl')

      keywords = search_string.split(' ')
      current_query = "\"#{search_string}\""
      result = []#self.search(current_query, :per_page => 1)
      puts 'current_query:' + current_query
      if result.length == 0
        current_query = ''
        keywords.each_with_index { |keyword, index|
          current_query += ' ' if index > 0
          current_query += "+#{keyword}"
        }
        puts 'current_query:' + current_query
        result = self.search(current_query, :per_page => 1)
        if result.length == 0
          current_query = ''
          keywords.each_with_index { |keyword, index|
            current_query += ' ' if index > 0
            current_query += "+#{keyword}*"
          }
          puts 'current_query:' + current_query
          result = self.search(current_query, :per_page => 1)
          if result.length == 0
            current_query = ''
            keywords.each_with_index { |keyword, index|
              current_query += ' ' if index > 0
              current_query += "+#{keyword}~1"
            }
            puts 'current_query:' + current_query
            result = self.search(current_query, :per_page => 1)
            if result.length == 0
              current_query = "#{search_string}"
              puts 'current_query:' + current_query
              result = self.search(current_query, :per_page => 1)
            end
          end
        end
      end
    end
    if result && !result.is_a?(ProductCategory)
      result = result.length > 0 ? ProductCategory.find(result[0]['id']) : nil
    end
    result
  end

  def self.all_children_by_id
    res = {}
    roots.all.each do |r|
      res[r.id] = []
      r.descendants.arrange(:order=>'`order`').each do |sec_level, third_level|
        res[r.id] << {:id=>sec_level.id, :name=>sec_level.name}
        res[sec_level.id] = third_level.map{|k,v| {:id=>k.id, :name=>k.name} }
      end
    end
    res
  end

  def self.get_merchant_by_names(popular_store, merchant_names)
    popular_stores = ProductCategory.where(popular: true).includes({hp_stores: :advertiser})
    popular_store = popular_stores.find_by_name(popular_store)
    merchant_by_names = {}
    merchant_names.each do |merchant_name|
      popular_store.hp_stores.each do |merchant|
        merchant_by_names[merchant_name] = merchant.advertiser if merchant_by_names[merchant_name].nil? && merchant.advertiser.name =~ /#{merchant_name}/
      end
    end
    merchant_by_names
  end
  
  def self.get_merchant(merchant_name)
    merchant = ''
    [IrAdvertiser, CjAdvertiser, PjAdvertiser, AvantAdvertiser, LinkshareAdvertiser].each do |klass|
      merchant = klass.where("name LIKE ?", merchant_name).first
      break if merchant.present?
    end
    merchant
  end
end
