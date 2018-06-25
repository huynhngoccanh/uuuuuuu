class PjAdvertiserCategoryMapping < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :pj_advertiser
  validates :product_category_id, :uniqueness => {:scope => :pj_advertiser_id}
end
