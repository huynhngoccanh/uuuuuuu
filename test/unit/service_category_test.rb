require 'test_helper'

class ServiceCategoryTest < ActiveSupport::TestCase
  test "make" do
    category = ServiceCategory.make
    assert category.save
  end
end
