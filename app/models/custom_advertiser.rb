class CustomAdvertiser < ActiveRecord::Base
  has_many :hp_stores, :dependent => :destroy
  has_one :hp_advertiser_image,  :as => :imageable, :dependent=>:destroy
  has_attached_file :logo #, :styles => { :thumb => "100x100>", :upload => "48x48>", :iphone=>"268x>", :iphone2x=>"536x>" }
  
  has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:custom_advertisers][:image]
 validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  
  validates_attachment_presence :logo,
    MuddleMe::Configuration.paperclip_options[:custom_advertisers][:logo]
  validates_attachment_content_type :logo, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  def id_with_class_name
    "#{self.class.name}.#{id}"
  end

end
