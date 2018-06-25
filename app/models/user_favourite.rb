class UserFavourite < ActiveRecord::Base
	belongs_to :user
  belongs_to :favorite_merchant, class_name: 'Merchant', foreign_key: :resource_id
end
