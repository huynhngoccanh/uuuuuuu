class PlacementSerializer < ActiveModel::Serializer
  attributes :id, :merchant_id, :location, :description, :code, :expiry, :header, :image_url
end
