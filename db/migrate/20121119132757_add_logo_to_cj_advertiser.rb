class AddLogoToCjAdvertiser < ActiveRecord::Migration
  def self.up
    change_table :cj_advertisers do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :cj_advertisers, :logo
  end
end
