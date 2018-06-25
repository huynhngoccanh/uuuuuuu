class Merchant < ActiveRecord::Base

	has_one :avant_advertiser
	has_one :cj_advertiser
	has_one :linkshare_advertiser
	has_one :pj_advertiser
	has_one :ir_advertiser
	has_many :coupons
	has_many :merchant_taxons
	has_many :taxons, through: :merchant_taxons
	has_many :loyalty_programs_users, foreign_key: :loyalty_program_id
	has_many :placements
	has_many :user_favourites , as: :resource
	has_many :clicks, as: :resource
	scope :loyalty, -> {where(loyalty_enabled: true)}
	after_create :update_merchant_slug

	has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:merchants][:image]
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  has_attached_file :icon,
    MuddleMe::Configuration.paperclip_options[:merchants][:icon]
  validates_attachment_content_type :icon, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

	def advertisers
		[avant_advertiser, linkshare_advertiser, cj_advertiser, pj_advertiser, ir_advertiser].compact
	end

	def advertisers_count
		advertisers.count.to_i
	end

	def advertiser_link
		advertisers.last.try(:base_tracking_url)
	end

	def redirection_link
		"/merchants/#{id}/redirect"
	end

	def taxon_names
		taxons.collect(&:name).join(", ")
	end

	def image_url
		image.url(:iphone)
	end

	def user_fav
		user_favourites ? true : false
	end

	def increment_used
		self.increment!(:used_counter)
  end

	def icon_url
		icon.url(:phone)
	end

	def update_merchant_slug
		self.update_column(:slug, "#{self.id}-#{self.name.parameterize}")
	end

	def browsablestore
		placements.find_by_location("BrowsableStores").try(:merchant).try(:name) ? true : false
	end

	def popular_merchant
		arr = []
		Taxon.most_popular.each do |char, taxons|
      taxons.each do |taxon|
        taxon.merchants.each do |merchant|
        	arr.push (merchant.try(:name))
        end
      end
    end
    arr.uniq ? true : false	
	end

	def name_downcase
		self.name.downcase	
	end
	def merchantname_concat
		self.downcase.gsub(" ","") 
	end

	searchable do
		boolean :active_status
		text :name, :boost => 2.0
		text :taxon_names
		string :name
		boolean :browsablestore
		# integer :view_counter
		string :name_downcase
	end
	
end
