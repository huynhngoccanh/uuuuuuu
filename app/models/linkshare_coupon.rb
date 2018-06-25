class LinkshareCoupon < ActiveRecord::Base
  belongs_to :advertiser, -> {where('linkshare_advertisers.inactive IS NULL or linkshare_advertisers.inactive=0')},
    :foreign_key => 'advertiser_id', :primary_key => 'advertiser_id', :class_name => 'LinkshareAdvertiser'

  attr_accessor :dont_require_code

  validates :advertiser_id, :presence => true
  validates :advertiser, :presence => true
  validates :header, :presence => true
  validates :code, :presence => true, :unless=>Proc.new{dont_require_code}
  has_one :coupon, as: :advertiser
  after_create :create_coupon_in_db

  def self.import_csv file
    first = true
    count = 0
    CSV.foreach(file, :headers => false) do |row|
      if first
        first = false
        next
      end
      existing_coupon = LinkshareCoupon.find_by_advertiser_id_and_code_and_header(row[1], row[3], row[2])
      if existing_coupon.nil?
        coupon = self.create({
                               :advertiser_name => row[0],
                               :advertiser_id => row[1],
                               :header => row[2],
                               :code => row[3],
                               :description => row[4],
                               :expires_at => row[5],
                               :manually_uploaded => true
                           })
        count +=1 if coupon.persisted?
      end
    end
    count
  end

  def set_attributes_from_response_row(row)
    self.advertiser_name = row['advertisername']
    self.advertiser_id = row['advertiserid']
    self.ad_url = row['clickurl']
    matches = /offerid=\d+\.(\d+)/.match(row['clickurl'])
    self.ad_id = matches.length > 1 ? matches[1] : nil
    self.description = row['offerdescription']
    self.header = row['promotiontypes']['promotiontype']#.join(', ')
    if row['couponcode'].blank?
      self.dont_require_code=true
    else
      self.code = row['couponcode']
    end

    self.expires_at = Date.strptime(row['offerenddate'], '%Y-%m-%d') rescue nil
    if self.expires_at.blank?
      puts "No Expiry date for :: #{self.advertiser_id.inspect} :: #{self.description.inspect}"
      begin
        format_regex = /\d{2}\/\d{2}/
        format_two_regex =  /\d{2}\/\d{2}-\d{2}\/\d{2}/
        if self.description =~ format_regex
          expiry_date = Date.parse(self.description)
          self.expires_at = expiry_date.to_s rescue nil
        elsif self.description =~ format_two_regex
          self.expires_at =~ Date.parse(self.description.split("-").last) rescue nil
        end
      rescue => e
        puts "#{e.message}::self.description"
      end
    end
    self
  end

  def self.reload_all_coupons
    response = Linkshare.coupons
    LinkshareCoupon.transaction do
      response.each do |row|
        begin
          matches = /offerid=\d+\.(\d+)/.match(row['clickurl'])
          coupon = matches.length > 1 ? self.where(ad_id: matches[1]).first_or_initialize : self.new
          coupon.set_attributes_from_response_row(row)
          existing_coupon = LinkshareCoupon.find_by_advertiser_id_and_code_and_header(coupon.advertiser_id, coupon.code, coupon.header)
          coupon.save if existing_coupon.nil?
        rescue Exception => ex
          p ex.message
        end
      end
    end
    # delete expired
    LinkshareCoupon.where('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(), INTERVAL 1 DAY)').update_all(deleted_at: DateTime.now)
    LinkshareCoupon.where(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)]).update_all(deleted_at: DateTime.now)

    # LinkshareCoupon.delete_all('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(),INTERVAL 1 DAY)')
    # LinkshareCoupon.delete_all(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)])
    User.admins.each do |developer|
      ContactMailer.new_coupons_data_notification("LinkshareCoupon", developer.email).deliver
    end
  end

  def create_coupon_in_db
    create_coupon(header: header, code: code,verified_at: Time.now, description: description, expires_at: expires_at, merchant_id: advertiser.try(:merchant_id), ad_url: ad_url)
  end

end