class Click < ActiveRecord::Base

	belongs_to :user
	belongs_to :resource, polymorphic: true
	before_create :set_user
	after_create :set_link

	searchable do 
		text	:user_email
		date	:created_at
	end

	def user_email
		user.try(:email)
	end

	def advertiser
		if resource_type == "Merchant"
			resource.advertisers.last
		else
			if resource.manually_uploaded
				resource.merchant.advertisers.last
			else
				if resource.advertiser
					resource.advertiser.advertiser
				end
			end
		end
	end

	
  def get_param_name
  	if advertiser.class.to_s == "AvantAdvertiser"
			"ctc"
		elsif advertiser.class.to_s == "CjAdvertiser"
			"sid"
		elsif advertiser.class.to_s == "IrAdvertiser"
			"subId1"
		elsif advertiser.class.to_s == "LinkshareAdvertiser"
			"u1"
		elsif advertiser.class.to_s == "PjAdvertiser"
			"sid"
		end
  end

  def set_link
  	if resource_type == "Merchant"
  		if advertiser
		    uri = Addressable::URI.parse(advertiser.base_tracking_url)
		    params = uri.query_values || {}
		    params[get_param_name] = self.id
		    uri.query_values = params
		    self.update_attributes(url: uri.to_s)
		  else
		  	self.update_attributes(url: resource.fallback_link)
		  end
	  else
	  	uri = Addressable::URI.parse((resource.ad_url.blank? ? advertiser.try(:base_tracking_url) : resource.ad_url))
	    if uri
		    params = uri.query_values || {}
		    params[get_param_name] = self.id
		    uri.query_values = params
		    self.update_attributes(url: uri.to_s)
		  end
	  end
  end

	def set_user
		self.user_id = PaperTrail.whodunnit
	end

	

end
