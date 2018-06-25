class AddSendMailFieldToEmailContents < ActiveRecord::Migration
  def change
    add_column :email_contents, :send_mail, :boolean, :default => true
  end
end
