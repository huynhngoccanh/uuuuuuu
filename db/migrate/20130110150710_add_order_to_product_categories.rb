class AddOrderToProductCategories < ActiveRecord::Migration
  class ProductCategory < ActiveRecord::Base
    has_ancestry
  end

  def up
    add_column :product_categories, :order, :integer

    root_order = 1
    ProductCategory.roots.order('name ASC').each do |r|
      r.update_attribute :order, root_order
      root_order += 1
      
      sec_level_order = 1
      sec_level_move_to_end = []
      r.children.order('name ASC').each do |sec_level|
        if sec_level.name.downcase.strip == 'other'
          sec_level_move_to_end << sec_level
        else
          sec_level.update_attribute :order, sec_level_order
          sec_level_order += 1
        end

        third_level_order = 1
        third_level_move_to_end = []
        sec_level.children.order('name ASC').each do |third_level|
          if third_level.name.downcase.strip == 'other'
            third_level_move_to_end << third_level
          else
            third_level.update_attribute :order, third_level_order
            third_level_order += 1
          end
        end
        third_level_move_to_end.each do |third_level|
          third_level.update_attribute :order, third_level_order
          third_level_order += 1
        end
      end
      sec_level_move_to_end.each do |sec_level|
        sec_level.update_attribute :order, sec_level_order
        sec_level_order += 1
      end
    end
  end

  def down
    remove_column :product_categories, :order
  end
end
