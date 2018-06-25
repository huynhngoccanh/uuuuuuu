class AddEmailContentForAuctionHasSomeBidsUser < ActiveRecord::Migration
  class EmailContent < ActiveRecord::Base
    validates :name, :uniqueness => true
  end

  def up
    EmailContent.create(:name=>'auction_has_some_bids_user')
  end

  def down
    EmailContent.where(:name=>'auction_has_some_bids_user').destroy
  end
end
