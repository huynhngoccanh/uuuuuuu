require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "make" do
    user = User.make
    assert user.save
  end
end
