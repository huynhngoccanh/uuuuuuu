class FavoriteMerchant < ActiveRecord::Base
  belongs_to :user
  belongs_to :advertisable, :polymorphic => true
  
end
