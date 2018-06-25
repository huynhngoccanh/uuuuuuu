class AddOfferVideoToOffers < ActiveRecord::Migration
  def change
    change_table :offers do |t|
      t.attachment :offer_video
    end
  end
end
