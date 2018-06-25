class LoyaltyProgramCoupon < ActiveRecord::Base
  belongs_to :loyalty_program
  
  attr_accessor :dont_require_code
  
  
  
  validates :loyalty_program_id, :presence => true
  validates :loyalty_program_name, :presence => true
  #validates :header, :presence => true, :unless=>Proc.new{dont_require_header}
 # validates :code, :presence => true,:unless=>Proc.new{dont_require_code}
  #validates_uniqueness_of :code, :scope => [:loyalty_program_id, :header], :case_sensitive => false

  #CODE_REGEXP = /(code|Code|CODE)(: | | "|: ")([a-zA-Z0-9]{4,20})/
  
  has_attached_file :barcode_image, 
    MuddleMe::Configuration.paperclip_options[:loyalty_program_coupons][:barcode_image]
  
  validates_attachment_content_type :barcode_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  def barcode_image_url
    barcode_image.url
  end
  
  
end
