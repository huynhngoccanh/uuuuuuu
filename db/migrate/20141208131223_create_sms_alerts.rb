class CreateSmsAlerts < ActiveRecord::Migration
  def change
    create_table :sms_alerts do |t|
      t.string :from_phone_number
      t.string :receiver_phone_number
      t.string :status
      t.string :twilio_uri
      t.references :user
      t.timestamps
    end
  end
end
