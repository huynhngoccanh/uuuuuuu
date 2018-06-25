class MerchantSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :loyalty_enabled, :redirection_link, :color_palette, :icon_url
  has_many :placements
end
