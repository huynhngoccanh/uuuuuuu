class HpAdvertiserImage < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  has_attached_file :hp_image,
    MuddleMe::Configuration.paperclip_options[:hp_advertiser_images][:hp_image]
  has_attached_file :hp_logo,
    MuddleMe::Configuration.paperclip_options[:hp_advertiser_images][:hp_logo]
  validates_attachment_presence :hp_image, :allow_nil => true, :if => :hp_image?
  validates_attachment_content_type :hp_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES, :allow_blank => true
  validates_attachment_content_type :hp_logo, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
end
