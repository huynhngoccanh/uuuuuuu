module Offerable
  extend ActiveSupport::Concern

  included do
    has_many :campaigns, :dependent=>:restrict_with_error
    has_attached_file :offer_video,
      MuddleMe::Configuration.paperclip_options[:loyalty_program_offers][:offer_video]
    attr_accessible :offer_video_file_name, :offer_video_content_type, :offer_video_file_size

    validates_attachment_content_type :offer_video, :content_type=>BROWSER_SUPPORTED_VIDEO_MIME_TYPES
    validates :name, :presence=>true, :length => { :maximum => 200 }
    validates :coupon_code, :length => { :maximum => 200 }
    validates :offer_url, :length => { :maximum => 200 }, :format => /[-a-zA-Z0-9@:%_\+.~#?&\/\/=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i , 
              :allow_blank=>true
    #parsable by URI parser        
    validate do
      unless offer_url.blank?
        begin
          URI.parse(offer_url)
        rescue
          errors.add(:offer_url, 'is invalid') #FIXME get this from i18n texts
        end
      end
    end

    default_scope -> {where(:is_deleted=>false)}
  end
  
  def offer_video_url
    offer_video.url
  end

  module ClassMethods
  end
    
  def to_api_json
    attrs = [:name, :coupon_code, :offer_url, :offer_description, :expiration_time]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:images] = offer_images.map(&:to_api_json)
    result
  end
  
end