class TaxonSerializer < ActiveModel::Serializer

  attributes :id, :name, :parent_id, :in_popular_store
  has_many :merchants

end
