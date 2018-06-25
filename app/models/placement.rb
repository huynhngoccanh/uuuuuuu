class Placement < ActiveRecord::Base
	belongs_to :merchant
	has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:placements][:image]

  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  scope :top_deals, -> {
    where(location: 'TopDeal').order("updated_at desc")
  }

  scope :fav_stores, -> {
    where(location: 'FavStores').order("updated_at desc")
  }

  after_save :create_coupon

  def merge_attr
    self.attributes.merge(
      merchant_name: self.merchant.name, 
      merchants_redirect_path: "/merchants/#{self.merchant.id}/redirect"
    )
  end

  def image_url
  	image.url(:medium)
  end

  def create_coupon
    @coupon = Coupon.find_or_initialize_by(code: self.code)
    @coupon.update_attributes(header: self.header, code: self.code, description: self.description, merchant_id: self.merchant_id, expires_at: self.expiry, print_file_name: self.image)
    @coupon.save
  end
end
