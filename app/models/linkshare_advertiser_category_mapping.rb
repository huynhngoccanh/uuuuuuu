class LinkshareAdvertiserCategoryMapping < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :linkshare_advertiser
  validates :product_category_id, :uniqueness => {:scope => :linkshare_advertiser_id}
end
