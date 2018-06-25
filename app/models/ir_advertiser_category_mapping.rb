class IrAdvertiserCategoryMapping < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :ir_advertiser
  validates :product_category_id, :uniqueness => {:scope => :ir_advertiser_id}
end
