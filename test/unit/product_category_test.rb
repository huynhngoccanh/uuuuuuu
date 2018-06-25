require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  test "make" do
    category = ProductCategory.make
    assert category.save
  end
end
