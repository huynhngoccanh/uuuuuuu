module Admins::EmailContentsHelper

  def prepare_email_content(text, args = {})
    return if text.blank?
    text.gsub(/\(\([^\(]+\)\)/) {|s|
      case s
        when "((search_number))" then "#{args[:search].try(:id)}"
        when "((search_intent))" then "#{args[:search].try(:search)}"
        when "((user_first_name))" then "#{args[:user].try(:first_name)}"
        when "((user_last_name))" then "#{args[:user].try(:last_name)}"
        when "((user_email))" then "#{args[:user].try(:email)}"
        when "((vendor_first_name))" then "#{args[:vendor].try(:first_name)}"
        when "((vendor_last_name))" then "#{args[:vendor].try(:last_name)}"
        when "((vendor_email))" then "#{args[:vendor].try(:email)}"
        when "((campaign_name))" then "#{args[:campaign].try(:name)}"
        when "((offer_name))" then "#{args[:campaign].try(:offer).try(:name)}"
        when "((affiliate_name))" then "#{args[:merchant].try(:company_name)}"
        else nil
      end
    }
  end

end