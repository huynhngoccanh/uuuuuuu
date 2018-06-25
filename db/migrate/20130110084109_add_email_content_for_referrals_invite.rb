class AddEmailContentForReferralsInvite < ActiveRecord::Migration
  
  class EmailContent < ActiveRecord::Base
    validates :name, :uniqueness => true
  end

  def up
    EmailContent.create(:name=>'referrals_invite')
  end

  def down
    EmailContent.where(:name=>'referrals_invite').destroy
  end
end
