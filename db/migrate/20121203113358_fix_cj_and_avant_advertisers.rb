class FixCjAndAvantAdvertisers < ActiveRecord::Migration
  class CjAdvertiser < ActiveRecord::Base
  end

  class AvantAdvertiser < ActiveRecord::Base
  end

  def up
    CjAdvertiser.where(:inactive=>[false,nil]).each do |a|
      CjAdvertiser.where(:advertiser_id=>a.advertiser_id, :inactive=>true).delete_all
    end
    AvantAdvertiser.where(:inactive=>[false,nil]).each do |a|
      AvantAdvertiser.where(:advertiser_id=>a.advertiser_id, :inactive=>true).delete_all
    end

    add_index "cj_advertisers", ["advertiser_id"], :name => "index_cj_advertisers_on_advertiser_id", :unique => true
    add_index "avant_advertisers", ["advertiser_id"], :name => "index_avant_advertisers_on_advertiser_id", :unique => true
  end

  def down
  end
end
