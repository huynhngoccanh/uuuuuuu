class IrCoupon < ActiveRecord::Base
  belongs_to :advertiser, -> {where('ir_advertisers.inactive IS NULL or ir_advertisers.inactive=0')},
    :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :class_name=>'IrAdvertiser'

  attr_accessor :dont_require_expires_at, :dont_require_code, :dont_require_header

  validates :advertiser_id, :presence => true
  validates :advertiser, :presence => true
  validates :header, :presence => true, :unless=>Proc.new{dont_require_header}
  validates :code, :presence => true, :unless=>Proc.new{dont_require_code}
  validates_uniqueness_of :code, :scope => [:advertiser_id, :header, :ad_id], :case_sensitive => false, :allow_nil => true
  validates :expires_at, :presence => true, :unless=>Proc.new{dont_require_expires_at}
  has_one :coupon, as: :advertiser
  after_create :create_coupon_in_db

  CODE_REGEXP = /(code|Code|CODE)(: | | "|: ")([a-zA-Z0-9]{4,20})/

  def self.reload_all_coupons
    inserted_count = 0
    page = 0
    begin
      page += 1
      coupons = IR.coupons page
      unless coupons.blank?
        IrCoupon.transaction do
          begin
            coupons.each do |row|
              coupon = self.where(ad_id: row['Id']).first_or_initialize
              saved = coupon.set_attributes_from_response_row(row).save
              inserted_count += 1 if saved
            end
          rescue Exception => ex
            p ex.message
          end
        end
      end
    end
    IrCoupon.where('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(), INTERVAL 1 DAY)').update_all(deleted_at: DateTime.now)
    IrCoupon.where(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)]).update_all(deleted_at: DateTime.now)


    # IrCoupon.delete_all('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(),INTERVAL 1 DAY)')
    # IrCoupon.delete_all(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)])
    inserted_count
    User.admins.each do |developer|
      ContactMailer.new_coupons_data_notification("IrCoupon", developer.email).deliver
    end
  end

  def set_attributes_from_response_row row
    self.advertiser_name = row['CampaignName']
    self.advertiser_id        = row['CampaignId']
    self.ad_id                       = row['Id']
    self.ad_url                     = row['TrackingLink']
    if row['LinkText'].nil? || row['LinkText']==""
          self.dont_require_header=true
    else
          self.header                    = row['LinkText']
    end

    if row['PromoCode'].nil? || row['PromoCode']==""
        self.dont_require_code=true
    else
      self.code                        = row['PromoCode']
    end

    self.description           = row['LinkText']
    #self.start_date             = Date.strptime(row['StartDate'], '%Y-%m-%d') rescue nil
    self.start_date             = Date.strptime(row['StartDate'], '%Y-%m-%d')
    if row['EndDate'].nil? || row['EndDate']==""
      self.dont_require_expires_at=true
    else
     # self.expires_at             = Date.strptime(row['EndDate'], '%Y-%m-%d') rescue nil
     self.expires_at             = Date.strptime(row['EndDate'], '%Y-%m-%d')
    end


#    if self.expires_at.blank?
#      puts "No Expiry date for :: #{self.advertiser_id.inspect} :: #{self.description.inspect}"
#      begin
#        format_regex = /\d{2}\/\d{2}/
#        format_two_regex =  /\d{2}\/\d{2}-\d{2}\/\d{2}/
#        if self.description =~ format_regex
#          expiry_date = Date.parse(self.description)
#          self.expires_at = expiry_date.to_s rescue nil
#        elsif self.description =~ format_two_regex
#          self.expires_at =~ Date.parse(self.description.split("-").last) rescue nil
#        end
#      rescue => e
#        puts "#{e.message}::self.description"
#      end
#    end
    self
  end

  # def self.parse_coupon_code(coupon_code)
  #   ignore_array = ["n/a", "NA", "N/A", "no code needed", "No code required", "None Required", "No coupon code necessary", "none needed", "No Code Necessary", "none require", "No Coupon Coded Needed", "None"]
  #   result = nil
  #
  #   matches = CODE_REGEXP.match(coupon_code)
  #
  #   if matches
  #     result = matches[3]
  #   end
  #
  #   result = nil if ignore_array.include?(result)
  #   result
  # end

  def self.import_csv file
    first = true
    count = 0
    CSV.foreach(file, :headers => false) do |row|
      if first
        first = false
        next
      end

      coupon = self.create({
          :advertiser_name=>row[0],
          :advertiser_id=>row[1],
          :header=>row[2],
          :code=>row[3],
          :description=>row[4],
          :expires_at=> row[5],
          :manually_uploaded => true
        })
      count +=1 if coupon.persisted?
    end
    count
  end

  def create_coupon_in_db
    create_coupon(header: header,verified_at: Time.now, code: code, description: description, expires_at: expires_at, merchant_id: advertiser.try(:merchant_id), ad_url: ad_url)
  end

end
