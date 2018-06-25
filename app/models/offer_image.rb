class OfferImage < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :offer
  belongs_to :vendor
  
#  has_attached_file :image, 
#    :styles => { :banner => "617x380>", :upload => "48x48>", :iphone=>"268x>", :iphone2x=>"536x>" },
#    :url=>'/system/offer_images/:id/:style/:filename'
  
  has_attached_file :image, 
    MuddleMe::Configuration.paperclip_options[:offer_images][:image]
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  #TODO !!!! validates_attachment_size :image, 
  
  def image_url
    image.url
  end
  
  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.url(:upload),
      "delete_url" => offer_image_path(:id => id),
      "delete_type" => "DELETE" 
    }
  end

   def to_api_json
    {
      "image_url" =>"http://#{HOSTNAME_CONFIG['full_hostname']}#{image.url(:iphone, false)}",
      "image_url_2x" => "http://#{HOSTNAME_CONFIG['full_hostname']}#{image.url(:iphone2x, false)}"
    }
  end
  
end
