class Coupon < ActiveRecord::Base

	belongs_to :advertiser, polymorphic: true
	belongs_to :merchant
	belongs_to :user
	validates :temp_website, presence: true, on: :create, if: Proc.new { |c| c.manually_uploaded }
	validates :code, presence: true, on: :create, if: Proc.new { |c| c.coupon_type == "with_code" }
	validates :print, attachment_presence: true, on: :create, if: Proc.new { |c| c.coupon_type == "printable" }
	

	validates_uniqueness_of :code, :scope => [:expires_at,:merchant_id],:allow_blank => true, :allow_nil => true, if: Proc.new { |question| question.coupon_type == nil||question.coupon_type ==''}, :message => 'Coupon Code should be unique'
	validates :header, uniqueness:{:scope => [:expires_at]},:allow_blank => true, :allow_nil => true
	has_attached_file :print,
    MuddleMe::Configuration.paperclip_options[:coupons][:print]
  validates_attachment_content_type :print, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  has_many :clicks, as: :resource


	def merchant_name
			merchant.try(:name)
	end

	searchable do
		text :header
		text :description
		text :merchant_name
		string :merchant_name
		date :expires_at
		integer	:views
		string :code
		integer :merchant_id
		date :created_at
	end
	def image
		try(:print).url
		
	end


	def submitted_by
		if user_id.blank?
			"Ubitru Admin"
		else
			if user.admin? 
				"Ubitru Admin"
			else
				user.full_name
			end
		end
	end
	
	def self.set_me
		AvantCoupon.all.collect do |ac|
			if ac.coupon.blank?
				ac.create_coupon_in_db
			end
		end
		CjCoupon.all.collect do |cc|
			if cc.coupon.blank?
				cc.create_coupon_in_db
			end
		end
		LinkshareCoupon.all.collect do |lc|
			if lc.coupon.blank?
				lc.create_coupon_in_db
			end
		end
		PjCoupon.all.collect do |pc|
			if pc.coupon.blank?
				pc.create_coupon_in_db
			end
		end
		IrCoupon.all.collect do |ic|
			if ic.coupon.blank?
				ic.create_coupon_in_db
			end
		end
	end

end