class ServiceRequest < ActiveRecord::Base
  belongs_to :user


  searchable do
  	text	:user_email
  	# text	:completetion_number 
  	text	:keyword
    date :created_at
  end
	
	def user_email
		user.try(:email)
	end


end
