class ChangeProductCategoriesAndServiceCategories < ActiveRecord::Migration

  class ProductCategory < ActiveRecord::Base
    has_ancestry

    has_many :auctions, :dependent => :restrict_with_error
    has_and_belongs_to_many :campaigns
    has_and_belongs_to_many :vendors

    def destroy_unused_categories
      children.each do |ch|
        ch.destroy_unused_categories
      end
      if children.blank? && auctions.blank? && campaigns.blank? && vendors.blank?
        destroy
      end
    end
  end


  def up
    ServiceCategory.all.each do |sc|
      if sc.auctions.blank? && sc.campaigns.blank? && sc.vendors.blank?
        sc.destroy
      end
    end

    ProductCategory.roots.each do |pc|
      pc.destroy_unused_categories
    end
  end

  def down
  end
end