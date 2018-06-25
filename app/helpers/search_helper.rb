module SearchHelper
  def get_user_info(user)
    user ? {:score => user.score, :balance => user.total_balance, :skip_info_before_shopping => !session[:skip_info_before_shopping].nil?} : nil
  end

  def get_logo
    imgs = Dir.glob(Rails.root.join('public', 'system', 'search_logo/*'))
    imgs && imgs.length == 1 ? '/system/search_logo/' + File.basename(imgs[0]) : nil
  end

  def is_mobile?
    (request.user_agent =~ /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i).present?
  end

  def make_query_string_bold(text, query_string)
    text.gsub(query_string, "<b>#{query_string}</b>").gsub(query_string.capitalize, "<b>#{query_string.capitalize}</b>").gsub(query_string.upcase, "<b>#{query_string.upcase}</b>").gsub(query_string.downcase, "<b>#{query_string.downcase}</b>").html_safe
  end

  def find_advertiser(db_id, merchant_type)
    case merchant_type
      when "Search::LinkshareMerchant"
        advertiser = LinkshareAdvertiser.find_by_id(db_id)
      when "Search::AvantMerchant"
        advertiser = AvantAdvertiser.find_by_id(db_id)
      when "Search::PjMerchant"
        advertiser = PjAdvertiser.find_by_id(db_id)
      when "Search::IrMerchant"
        advertiser = IrAdvertiser.find_by_id(db_id)
      when "Search::CjMerchant"
        advertiser = CjAdvertiser.find_by_id(db_id)
    end
    advertiser
  end
end
