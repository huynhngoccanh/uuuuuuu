class AddRecomendationsSentAtToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :recommendations_sent_at, :datetime
  end
end
