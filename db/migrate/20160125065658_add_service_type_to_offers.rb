class AddServiceTypeToOffers < ActiveRecord::Migration
  def self.up
      add_column :offers, :service_type, :string,  :limit => 10
      Offer.where(product_offer: true).update_all(service_type: "product")
      Offer.where(product_offer: false).update_all(service_type: "service")
  end
  def self.down
    remove_column :offers, :service_type
  end
end
