XmlBuilder = Builder

class RecognizeImage < ActiveRecord::Base

  ETILIZE_BASE_IMAGE = ['650', '500', '300', '225', '160']
  ETILIZE_EXTRA_IMAGE = ['Rear', 'Front', 'Right', 'Left', 'Top', 'Bottom']

  def set_attributes_from_etilize_response_row row, image_type
    self.etilize_id = row['id']
    self.etilize_image_type = image_type
  end

  def set_attributes_from_best_buy_response_row row
    self.best_buy_id = row['sku']
    self.best_buy_product_name = row['name']
    self.best_buy_image_url = row['largeFrontImage']
  end

  def self.fetch_all_etilize showProgressbar=false
    page = 0
    inserted_count = 0
    bar = nil
    
    begin 
      page += 1
      response = Etilize.all_with_images(page, '')
      products = response['products']['productSummary']
      products = [products] if !products.is_a? Array
      if showProgressbar && !bar
        bar = RakeProgressbar.new((response['count'].to_i / Etilize::PER_PAGE) + 1)
      end

      products.each do |product|
        next if !product['resources']
        images = product['resources']['resource']
        images = [images] if !images.is_a? Array
        available_base_types = []
        available_extra_types = []
        images.each do |image|
          next if image['status'] != 'Published'
          available_base_types << image['type'] if ETILIZE_BASE_IMAGE.include?(image['type']) 
          available_extra_types << image['type'] if ETILIZE_EXTRA_IMAGE.include?(image['type']) 
        end
        unless available_base_types.empty?
          recognize_image = self.new
          recognize_image.set_attributes_from_etilize_response_row product, available_base_types.map(&:to_i).max.to_s
          saved = recognize_image.save
          inserted_count += 1 if saved
        end
        available_extra_types.each do |type|
          recognize_image = self.new
          recognize_image.set_attributes_from_etilize_response_row product, type
          saved = recognize_image.save
          inserted_count += 1 if saved
        end
      end
      bar.inc if bar
    end until (page-1) * Etilize::PER_PAGE + products.length >= response['count'].to_i
    bar.finished if bar
    inserted_count
  end

  def self.fetch_all_best_buy showProgressbar=false
    page = 0
    inserted_count = 0
    http = HTTPClient.new
    bar = nil
    limit = 1000
    begin
      page += 1
      response = BestBuy.all_with_images page
      break if response.nil? || response['products'].blank? || response['products']['product'].blank?
      products = response['products']['product']
      products = [products] if !products.is_a? Array

      response['products']

      if showProgressbar
        bar ||= RakeProgressbar.new([response['products']['total'].to_i, limit].min)
      end

      products.each do |row|
        # image = best_buy_movie_cover_url row
        # image_req = http.get(image)
        # next if image_req.http_header.status_code != 200
        recognize_image = self.new
        recognize_image.set_attributes_from_best_buy_response_row row
        saved = recognize_image.save
        inserted_count += 1 if saved
        bar.inc if bar 
        break if inserted_count == limit
      end
    end until inserted_count == limit || (response['products']['curentPage'].to_i == response['products']['totalPages'].to_i)
  end

  def etilize_image_url
    "http://content.etilize.com/#{etilize_image_type}/#{etilize_id}.jpg"
  end

  def self.best_buy_movie_cover_url row
     "http://pisces.bbystatic.com/entertainment/movie/image/id/#{row['upc']};size=m2"
  end

  def best_buy_with_canvas_url
    path = best_buy_image_url.gsub('http://images.bestbuy.com/','')
    "http://pisces.bbystatic.com/image2/#{path};canvasHeight=500;canvasWidth=500"
  end

  def self.generate_xml_for_recognize
    file = File.new(Rails.root.join('public/recognize.xml'),'w+')
    xml = XmlBuilder::XmlMarkup.new(:target => file)
    xml.instruct!
    xml.pictures(
      :"xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      :"xmlns"=>"http://recognize.im/schema/2012",
      :"xsi:schemaLocation"=>"http://recognize.im/schema/2012 http://recognize.im/schema/2012/1.0/schema.xsd"
      ) do 
      RecognizeImage.find_each do |i|
        xml.picture do
          xml.id(i.id)
          xml.url(i.best_buy_with_canvas_url)
          xml.name(i.best_buy_product_name)
        end
      end
    end
    file.close
  end
end
