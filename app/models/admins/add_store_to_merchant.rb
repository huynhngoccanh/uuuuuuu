class Admins::AddStoreToMerchant < ActiveRecord::Base
  self.table_name = "store_category_merchants"
  #belongs_to :advertiser_id, polymorphic: true
  validates_uniqueness_of :store_cat_id, :scope => [:advertiser_id,:advertiser_type]
  #validates_uniqueness_of :store_cat_id, :scope => :advertiser_type
end
