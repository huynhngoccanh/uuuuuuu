class AuctionImage < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :user
  belongs_to :auction
  
  has_attached_file :image, 
    MuddleMe::Configuration.paperclip_options[:auction_images][:image]
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  #TODO !!!! validates_attachment_size :image, 
  
  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.url(:upload),
      "delete_url" => auction_image_path(:id => id),
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
