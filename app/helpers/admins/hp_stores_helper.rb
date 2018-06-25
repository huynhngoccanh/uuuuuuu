module Admins::HpStoresHelper

  def stores_page_name(type)
    case type
      when "browseable"
        name = "Browseable Stores"
      when "top_dealers"
        name = "Top Dealers"
      when "favorite_stores"
        name = "Favorite Stores"
    end
    return name
  end

end
