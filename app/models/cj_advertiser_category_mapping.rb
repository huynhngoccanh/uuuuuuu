class CjAdvertiserCategoryMapping < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :cj_advertiser
  validates :product_category_id, :uniqueness => {:scope => :cj_advertiser_id}
end
