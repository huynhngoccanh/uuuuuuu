class PersonalOffer < ActiveRecord::Base
  
  belongs_to :vendor
  
  has_attached_file :offer_video,
    MuddleMe::Configuration.paperclip_options[:personal_offers][:offer_video]
  validates :header, :offer_barcode_image, :expiration_date, :offer_image, presence: true

  validates_attachment_content_type :offer_video, :content_type=>BROWSER_SUPPORTED_VIDEO_MIME_TYPES
   
  has_attached_file :offer_barcode_image, 
    MuddleMe::Configuration.paperclip_options[:personal_offers][:offer_barcode_image]
  has_attached_file :offer_image, 
    MuddleMe::Configuration.paperclip_options[:personal_offers][:offer_image]
  
  validates_attachment_content_type :offer_barcode_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  validates_attachment_content_type :offer_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  

  def offer_barcode_image_url
    offer_barcode_image.url
  end
  
  def offer_image_url
    offer_image.url
  end
  
  def offer_video_url
    offer_video.url
  end
  
   def offer_url
    {
      video_url: offer_video_url,
      offer_image_url: offer_image_url,
      offer_barcode_image_url: offer_barcode_image_url
    }
  end

  
end
