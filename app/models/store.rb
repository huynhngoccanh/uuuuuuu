class Store < ActiveRecord::Base

  belongs_to :storable, :polymorphic => true
  # acts_as_mappable
  has_many :store_product_categories
  has_many :product_categories, through: :store_product_categories


  def self.import_stores_from_csv(file, advertiser)
    first = true
    count = 0
    CSV.foreach(file, :headers => false) do |row|
      if first
        first = false
        next
      end

      store = advertiser.stores.create({
        :name => row[0],
        :address => row[1],
        :lat => (row[2].blank?) ? nil : row[2].split(",").first,
        :lng => (row[2].blank?) ? nil : row[2].split(",").last
        })
        count +=1 if store.persisted?
      end
      count
    end
    
    def self.import_stores_for_loyalty_program(file, loyalty_program)
       spreadsheet = open_spreadsheet(file)
       (1..spreadsheet.last_row).each do |i|
         row = spreadsheet.row(i)
         store = find_by_address(spreadsheet.row(i)[1]) || new
         store.name=spreadsheet.row(i)[0]
         store.address=spreadsheet.row(i)[1]
         latlng=spreadsheet.row(i)[2].split(',')
         store.lat=latlng[0].to_f
         store.lng=latlng[1].to_f
         if store.storable_type.nil? || store.storable_id
           store.storable_type="LoyaltyProgram"
           store.storable_id=loyalty_program.id
         end
         store.save
       end
    end
    
    def self.open_spreadsheet(file)
        case File.extname(file.original_filename)
        when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"
        end
    end



  def calculate_distance(lat,lng)
      radius= 6371
      d_lat = ((Math::PI/180)*(self.lat.to_f-lat))
      d_lng = ((Math::PI/180)*(self.lng.to_f-lng)) 
      a = Math.sin(d_lat/2) * Math.sin(d_lat/2)+ Math.cos((Math::PI/180)*(lat)) * Math.cos((Math::PI/180)*(self.lat.to_f)) * Math.sin(d_lng/2) * Math.sin(d_lng/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = radius * c
  end

end
