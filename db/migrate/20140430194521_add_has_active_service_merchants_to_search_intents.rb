class AddHasActiveServiceMerchantsToSearchIntents < ActiveRecord::Migration
  def up
    add_column :search_intents, :has_active_service_merchants, :boolean, :default => false
    Search::Intent.all.each do |intent|
      types = intent.merchants.map { |elem| (elem.type if elem.active) }.compact
      intent.has_active_service_merchants = types.include?(Search::SoleoMerchant.name) || types.include?(Search::LocalMerchant.name)
      intent.save
    end
  end

  def down
    remove_column :search_intents, :has_active_service_merchants
  end
end
