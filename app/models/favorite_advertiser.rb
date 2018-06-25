class FavoriteAdvertiser < ActiveRecord::Base
  belongs_to :user
  belongs_to :cj_advertiser
  belongs_to :avant_advertiser
  belongs_to :linkshare_advertiser
  belongs_to :pj_advertiser
  belongs_to :ir_advertiser

  validates_uniqueness_of :cj_advertiser_id, :scope => :user_id, :message => 'This merchant has already been selected.', allow_nil: true
  validates_uniqueness_of :avant_advertiser_id, :scope => :user_id, :message => 'This merchant has already been selected.',allow_nil: true
  validates_uniqueness_of :linkshare_advertiser_id, :scope => :user_id, :message => 'This merchant has already been selected.',allow_nil: true
  validates_uniqueness_of :pj_advertiser_id, :scope => :user_id, :message => 'This merchant has already been selected.',allow_nil: true
  validates_uniqueness_of :ir_advertiser_id, :scope => :user_id, :message => 'This merchant has already been selected.',allow_nil: true

  def advertiser=(id_with_class_name)
    pair = id_with_class_name.split('.')
    case pair[0]
      when CjAdvertiser.name
        self.cj_advertiser_id = pair[1]
      when AvantAdvertiser.name
        self.avant_advertiser_id = pair[1]
      when LinkshareAdvertiser.name
        self.linkshare_advertiser_id = pair[1]
      when PjAdvertiser.name
        self.pj_advertiser_id = pair[1]
      else
        self.ir_advertiser_id = pair[1]
    end
  end

  def advertiser
    #(cj_advertiser_id.present?) ? (cj_advertiser) : (avant_advertiser_id.present?) ? (avant_advertiser) : (linkshare_advertiser_id.present?) ? (linkshare_advertiser) : (pj_advertiser)
    if cj_advertiser_id.present?
      return cj_advertiser
    elsif avant_advertiser_id.present?
      return avant_advertiser
    elsif linkshare_advertiser_id.present?
      return linkshare_advertiser
    elsif pj_advertiser_id.present?
      return pj_advertiser
    else
      ir_advertiser
    end
  end

  def self.replacing_advertiser(id_with_class_name)
    pair = id_with_class_name.split('.')
    case pair[0]
      when CjAdvertiser.name
        replace(pair[0], pair[1])
      when AvantAdvertiser.name
        replace(pair[0], pair[1])
      when LinkshareAdvertiser.name
        replace(pair[0], pair[1])
      when PjAdvertiser.name
        replace(pair[0], pair[1])
      else
        replace(pair[0], pair[1])
    end
  end

  def self.adv_column_name(class_name)
      (class_name.tableize.singularize + "_id").to_sym
  end

  def self.replace(adv_class_name, adv_id)
      all_advertisers = [CjAdvertiser.name, AvantAdvertiser.name, LinkshareAdvertiser.name, PjAdvertiser.name, IrAdvertiser.name]
      ignored_advertisers = all_advertisers - [adv_class_name]
      advertisers_hash = Hash[ignored_advertisers.map{ |key, value| [adv_column_name(key), nil] }]
      advertisers_hash.merge!(adv_column_name(adv_class_name) => adv_id)
  end

  def self.non_fav_advertisers(adv_class_name, user)
    case adv_class_name
      when CjAdvertiser.name
        CjAdvertiser.select([:name, :id]).where("id NOT IN (?)", user.favorite_advertisers.select(:cj_advertiser_id).map(&:cj_advertiser_id).compact)
      when AvantAdvertiser.name
        AvantAdvertiser.select([:name, :id]).where("id NOT IN (?)", user.favorite_advertisers.select(:avant_advertiser_id).map(&:avant_advertiser_id).compact)
      when LinkshareAdvertiser.name
        LinkshareAdvertiser.select([:name, :id]).where("id NOT IN (?)", user.favorite_advertisers.select(:linkshare_advertiser_id).map(&:linkshare_advertiser_id).compact)
      when PjAdvertiser.name
        PjAdvertiser.select([:name, :id]).where("id NOT IN (?)", user.favorite_advertisers.select(:pj_advertiser_id).map(&:pj_advertiser_id).compact)
      else
        IrAdvertiser.select([:name, :id]).where("id NOT IN (?)", user.favorite_advertisers.select(:ir_advertiser_id).map(&:ir_advertiser_id).compact)
    end

  end

end
