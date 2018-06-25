class HpStore < ActiveRecord::Base

  belongs_to :cj_advertiser
  belongs_to :avant_advertiser
  belongs_to :linkshare_advertiser
  belongs_to :pj_advertiser
  belongs_to :ir_advertiser
  belongs_to :custom_advertiser
  belongs_to :advertiser, polymorphic: true

  scope :browseable, -> {where(:store_type => "browseable")}
  scope :top_dealers, -> {where(:store_type => "top_dealers")}
  scope :favorite_stores, -> {where(:store_type => "favorite_stores")}
  scope :popular_stores, -> {where(:store_type => "popular_stores")}


  def self.optimize
    self.all.each do |hp|
      hp.update_attributes(advertiser_type: hp.advertiser.class.name, advertiser_id: hp.advertiser.id)
    end
  end

  # def advertiser=(id_with_class_name)
  #   pair = id_with_class_name.split('.')
  #   case pair[0]
  #     when CjAdvertiser.name
  #       self.cj_advertiser_id = pair[1]
  #     when AvantAdvertiser.name
  #       self.avant_advertiser_id = pair[1]
  #     when LinkshareAdvertiser.name
  #       self.linkshare_advertiser_id = pair[1]
  #     when PjAdvertiser.name
  #       self.pj_advertiser_id = pair[1]
  #     when IrAdvertiser.name
  #       self.ir_advertiser_id = pair[1]
  #     else
  #       self.custom_advertiser_id = pair[1]
  #   end
  # end
  
  def find_by_advertiser=(id_with_class_name)
    pair = id_with_class_name.split('.')
    case pair[0]
      when CjAdvertiser.name
        return HpStore.find_by_cj_advertiser_id(pair[1])
      when AvantAdvertiser.name
        return HpStore.find_by_avant_advertiser_id(pair[1])
      when LinkshareAdvertiser.name
        return HpStore.find_by_linkshare_advertiser_id(pair[1])
      when PjAdvertiser.name
        return HpStore.find_by_pj_advertiser_id(pair[1])
      when IrAdvertiser.name
        return HpStore.find_by_ir_advertiser_id(pair[1])
      else
        return HpStore.find_by_custom_advertiser_id(pair[1])
      
    end
  end

  def self.non_hp_stores(adv_class_name, store_type)
    case adv_class_name
      when CjAdvertiser.name
        CjAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:cj_advertiser_id).map(&:cj_advertiser_id).compact)
      when AvantAdvertiser.name
        AvantAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:avant_advertiser_id).map(&:avant_advertiser_id).compact)
      when LinkshareAdvertiser.name
        LinkshareAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:linkshare_advertiser_id).map(&:linkshare_advertiser_id).compact)
      when PjAdvertiser.name
        PjAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:pj_advertiser_id).map(&:pj_advertiser_id).compact)
      when IrAdvertiser.name
        IrAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:ir_advertiser_id).map(&:ir_advertiser_id).compact)
      else
        CustomAdvertiser.select([:name, :id]).where("id NOT IN (?)", HpStore.send(store_type).select(:custom_advertiser_id).map(&:custom_advertiser_id).compact)
    end
  end


  def self.added_stores(store_type)
    cj_stores = CjAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:cj_advertiser_id).map(&:cj_advertiser_id).compact).order("max_commission_percent DESC")
    avant_stores = AvantAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:avant_advertiser_id).map(&:avant_advertiser_id).compact).order("commission_percent DESC")
    linkshare_stores = LinkshareAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:linkshare_advertiser_id).map(&:linkshare_advertiser_id).compact).order("max_commission_percent DESC")
    pj_stores = PjAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:pj_advertiser_id).map(&:pj_advertiser_id).compact).order("max_commission_percent DESC")
    ir_stores = IrAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:ir_advertiser_id).map(&:ir_advertiser_id).compact).order("max_commission_percent DESC")
    custom_stores = CustomAdvertiser.where("id IN (?)", HpStore.send(store_type).select(:custom_advertiser_id).map(&:custom_advertiser_id).compact).order("max_commission_percent DESC")
    cj_stores + avant_stores + pj_stores + linkshare_stores + ir_stores + custom_stores    
    
    # case adv_class_name
    #   when CjAdvertiser.name
    #     CjAdvertiser.where("id IN (?)", HpStore.select(:cj_advertiser_id).map(&:cj_advertiser_id).compact)
    #   when AvantAdvertiser.name
    #     AvantAdvertiser.where("id IN (?)", HpStore.select(:avant_advertiser_id).map(&:avant_advertiser_id).compact)
    #   when LinkshareAdvertiser.name
    #     LinkshareAdvertiser.where("id IN (?)", HpStofavoritere.select(:linkshare_advertiser_id).map(&:linkshare_advertiser_id).compact)
    #   when PjAdvertiser.name
    #     PjAdvertiser.where("id IN (?)", HpStore.select(:pj_advertiser_id).map(&:pj_advertiser_id).compact)
    #   when IrAdvertiser.name
    #     IrAdvertiser.where("id IN (?)", HpStore.select(:ir_advertiser_id).map(&:ir_advertiser_id).compact)
    #   else
    #     CustomAdvertiser.where("id IN (?)", HpStore.select(:custom_advertiser_id).map(&:custom_advertiser_id).compact)
    # end

  end

  # def advertiser
  #   if cj_advertiser_id.present?
  #     return cj_advertiser
  #   elsif avant_advertiser_id.present?
  #     return avant_advertiser
  #   elsif linkshare_advertiser_id.present?
  #     return linkshare_advertiser
  #   elsif pj_advertiser_id.present?
  #     return pj_advertiser
  #   elsif ir_advertiser_id.present?
  #     return ir_advertiser
  #   else
  #     return custom_advertiser
  #   end
  # end

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
    when IrAdvertiser.name
      replace(pair[0], pair[1])
    else
      replace(pair[0], pair[1])
    end
  end

  def self.adv_column_name(class_name)
    (class_name.tableize.singularize + "_id").to_sym
  end

  def self.replace(adv_class_name, adv_id)
    all_advertisers = [CjAdvertiser.name, AvantAdvertiser.name, LinkshareAdvertiser.name, PjAdvertiser.name, IrAdvertiser.name, CustomAdvertiser.name]
    ignored_advertisers = all_advertisers - [adv_class_name]
    advertisers_hash = Hash[ignored_advertisers.map{ |key, value| [adv_column_name(key), nil] }]
    advertisers_hash.merge!(adv_column_name(adv_class_name) => adv_id)
  end

end
