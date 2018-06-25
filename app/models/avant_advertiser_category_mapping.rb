class AvantAdvertiserCategoryMapping < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :avant_advertiser
  validates :product_category_id, :uniqueness => {:scope => :avant_advertiser_id}
end
