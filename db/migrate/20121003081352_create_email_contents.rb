class CreateEmailContents < ActiveRecord::Migration
  def up
    create_table :email_contents do |t|
      t.string :name
      t.text :hello_sub_text

      t.timestamps
    end

    EmailContent.create(:name=>'auction_initiated_user')
    EmailContent.create(:name=>'auction_ended_user')
    EmailContent.create(:name=>'auction_won_user')
    EmailContent.create(:name=>'auction_won_vendor')
    EmailContent.create(:name=>'first_confirmation_reminder')
    EmailContent.create(:name=>'last_confirmation_reminder')
    EmailContent.create(:name=>'vendor_confirm_outcome')
    EmailContent.create(:name=>'low_funds_notification_global')
    EmailContent.create(:name=>'low_funds_notification_campaign')
    EmailContent.create(:name=>'recommended_auctions')

    #EmailContent.create(:name=>'bid_auction_user')

    #EmailContent.create(:name=>'contact_mail')

    EmailContent.create(:name=>'confirmation_instructions_user')
    EmailContent.create(:name=>'confirmation_instructions_vendor')
    #EmailContent.create(:name=>'reset_password_instructions_user')
    #EmailContent.create(:name=>'reset_password_instructions_vendor')

    #EmailContent.create(:name=>'invite')
  end

  def down
    drop_table :email_contents
  end

end
