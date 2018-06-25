require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test "make" do
    admin = Admin.make
    assert admin.save
  end
end
