class PrintableCoupon < ActiveRecord::Base
  belongs_to :user_coupon
  has_attached_file :coupon_image, 
    MuddleMe::Configuration.paperclip_options[:printable_coupons][:coupon_image]
  validates_attachment_content_type :coupon_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  #validates_attachment_content_type :coupon_image, :content_type => /Aimage\/.*\Z/
end
