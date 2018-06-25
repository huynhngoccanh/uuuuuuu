class AddEmailContentForAuctionEndedFromAffiliate < ActiveRecord::Migration
  class EmailContent < ActiveRecord::Base
    validates :name, :uniqueness => true
  end

  def up
    EmailContent.create(:name=>'auction_ended_from_affiliate')
  end

  def down
    EmailContent.where(:name=>'auction_ended_from_affiliate').destroy
  end
end
