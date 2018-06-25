class Facebookquery < ActiveRecord::Base


has_one :users

searchable do
	string :query
	date :created_at
end

def email
	User.where(user_bot_id: self.facebook_uid).first.try(:email)
	
end

end
