class AddExpirationTimeToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :expiration_time, :datetime
  end
end
