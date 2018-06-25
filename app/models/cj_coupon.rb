class CjCoupon < ActiveRecord::Base

   belongs_to :advertiser, -> {where('cj_advertisers.inactive IS NULL or cj_advertisers.inactive=0')} , :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id',
            :class_name=>'CjAdvertiser'
#  belongs_to :advertiser, :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id',
#            :class_name=>'CjAdvertiser'

  attr_accessor :dont_require_expires_at, :dont_require_code

  validates :advertiser_id, :presence => true
  validates :advertiser, :presence => true
  validates :header, :presence => true
  validates :code, :presence => true, :unless=>Proc.new{dont_require_code}
  validates_uniqueness_of :code, :scope => [:ad_id, :advertiser_id], :case_sensitive => false, :allow_nil => true
  validates :expires_at, :presence => true, :unless=>Proc.new{dont_require_expires_at}
  has_one :coupon, as: :advertiser
  after_create :create_coupon_in_db

  CODE_REGEXP = /(code|Code|CODE)(:| : | | "|: ")([a-zA-Z0-9]{4,20})/

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

  def set_attributes_from_response_row row
    self.advertiser_name = row['advertiser_name']
    self.advertiser_id   = row['advertiser_id']
    self.ad_id           = row['link_id']
    self.ad_url          = CjAdvertiser.tracking_url row['link_id']
    self.header      = row['link_name'].gsub(/[^0-9A-Za-z $-.]/, '')
    if row['coupon_code'].nil? || row['coupon_code']==""
       self.dont_require_code=true
    else
       self.code            = row['coupon_code']
    end

   # self.code            = CjCoupon.parse_coupon_code row['link_name'], row['description']
    self.description     = row['description'].gsub(/[^0-9A-Za-z $-.]/, '')

    if row['promotion_end_date'].nil? || row['promotion_end_date']==""
       self.dont_require_expires_at=true
    else
       self.expires_at      = Date.strptime(row['promotion_end_date'], '%Y-%m-%d') rescue nil
    end

       self.created_at      = Date.strptime(row['promotion_start_date'], '%Y-%m-%d') rescue nil

           # if self.expires_at.blank?
           #   puts "No Expiry date for :: #{self.advertiser_id.inspect} :: #{self.description.inspect}"
           #   begin
           #     format_regex = /\d{2}\/\d{2}/
           #     format_two_regex =  /\d{2}\/\d{2}-\d{2}\/\d{2}/
           #     if self.description =~ format_regex
           #       expiry_date = Date.parse(self.description)
           #       self.expires_at = expiry_date.to_s rescue nil
           #     elsif self.description =~ format_two_regex
           #       self.expires_at =~ Date.parse(self.description.split("-").last) rescue nil
           #     end
           #   rescue => e
           #     puts "#{e.message}::self.description"
           #   end
           # end

    self
  end

#  def self.parse_coupon_code(link_name, description)
#    ignore_array = %w(must expies expires field Banner found and)
#    result = nil
#
#    matches = CODE_REGEXP.match(link_name)
#    if matches
#      result = matches[3]
#    else
#      matches = CODE_REGEXP.match(description)
#      result = matches[3] if matches
#    end
#    result = nil if ignore_array.include?(result)
#    result
#  end

  def self.reload_all_coupons
    inserted_count = 0
    page = 0
    begin
      page += 1
      response = CJ.coupons page
      break if response.nil? || response['links'].blank? || response['links']['link'].blank?
      links = response['links']['link']
      links = [links] unless links.is_a? Array

      CjCoupon.transaction do
        begin
          links.each do |row|
            coupon = self.where(ad_id: row['link_id']).first_or_initialize
            saved = coupon.set_attributes_from_response_row(row).save
            inserted_count += 1 if saved
          end
        rescue Exception => ex
          p ex.message
        end
      end

    end until (page-1)* CJ::PER_PAGE + response['links']['records_returned'].to_i >= response['links']['total_matched'].to_i
    CjCoupon.where('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(), INTERVAL 1 DAY)').update_all(deleted_at: DateTime.now)
    CjCoupon.where(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)]).update_all(deleted_at: DateTime.now)

    # CjCoupon.delete_all('expires_at IS NOT NULL AND expires_at < DATE_SUB(NOW(), INTERVAL 1 DAY)')
    # CjCoupon.delete_all(["created_at < (?) AND expires_at IS NULL", (Date.today - 2.months)])
    inserted_count
    User.admins.each do |developer|
      ContactMailer.new_coupons_data_notification("Commission Junction", developer.email).deliver
    end
  end

  def to_api_json
    attrs = [:advertiser_name, :header, :code, :description]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
  end

  def create_coupon_in_db
    create_coupon(header: header, code: code, description: description, expires_at: expires_at,  merchant_id: advertiser.try(:merchant_id), ad_url: ad_url, verified_at: Time.now)
  end

end
