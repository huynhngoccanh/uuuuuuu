class PjCoupon < ActiveRecord::Base
  belongs_to :advertiser, -> {where('pj_advertisers.inactive IS NULL or pj_advertisers.inactive=0')},
    :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :class_name=>'PjAdvertiser'

  validates :advertiser_id, :presence => true
  validates :advertiser, :presence => true
  validates :header, :presence => true
  validates :code, :presence => true
  validates_uniqueness_of :code, :scope => [:advertiser_id, :header, :ad_id], :case_sensitive => false
  has_one :coupon, as: :advertiser
  after_create :create_coupon_in_db

  CODE_REGEXP = /(code|Code|CODE)(: | | "|: ")([a-zA-Z0-9]{4,20})/

  def self.reload_all_coupons
    inserted_count = 0
    page = 0
    begin
      page += 1
      response = PJ.coupons page
     # if response.nil? || response['data'].blank?
      coupons = response['data']
      coupons = [coupons] unless coupons.is_a? Array

      PjCoupon.transaction do
        begin
          coupons.each do |row|
            coupon = self.where(ad_id: row['id']).first_or_initialize
            saved = coupon.set_attributes_from_response_row(row).save
            inserted_count += 1 if saved
          end
        rescue Exception => ex
          p ex.message
        end
      end

    end until coupons.blank?
    PjCoupon.where('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(), INTERVAL 1 DAY)').update_all(deleted_at: DateTime.now)
    PjCoupon.where(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)]).update_all(deleted_at: DateTime.now)


    # PjCoupon.delete_all('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(),INTERVAL 1 DAY)')
    # PjCoupon.delete_all(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)])
    inserted_count
    User.admins.each do |developer|
      ContactMailer.new_coupons_data_notification("PjCoupon", developer.email).deliver
    end
  end

  def set_attributes_from_response_row row
    self.advertiser_name = row['program_name']
    self.advertiser_id   = row['program_id']
    self.ad_id           = row['id']
    self.ad_url          = row['code']
    self.header          = row['name']
    self.code            = row['coupon']
    self.description = row['description']
    self.start_date  = Date.strptime(row['start_date'], '%Y-%m-%d') rescue nil
    self.expires_at  = Date.strptime(row['end_date'], '%Y-%m-%d') rescue nil
    if self.expires_at.blank?
      #puts "No Expiry date for :: #{self.advertiser_id.inspect} :: #{self.description.inspect}"
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

  def self.parse_coupon_code(coupon_code)
    ignore_array = ["n/a", "NA", "N/A", "no code needed", "No code required", "None Required", "No coupon code necessary", "none needed", "No Code Necessary", "none require", "No Coupon Coded Needed", "None"]
    result = nil

    matches = CODE_REGEXP.match(coupon_code)

    if matches
      result = matches[3]
    end

    result = nil if ignore_array.include?(result)
    result
  end

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
    create_coupon(header: header, code: code, description: description,verified_at: Time.now, expires_at: expires_at, merchant_id: advertiser.try(:merchant_id), ad_url: ad_url)
  end

end
