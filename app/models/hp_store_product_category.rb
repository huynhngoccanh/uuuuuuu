class HpStoreProductCategory < ActiveRecord::Base
  belongs_to :hp_store
  belongs_to :product_category
end
