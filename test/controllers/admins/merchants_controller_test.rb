require 'test_helper'

class Admins::MerchantsControllerTest < ActionController::TestCase
  setup do
    @admins_merchant = admins_merchants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins_merchants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admins_merchant" do
    assert_difference('Admins::Merchant.count') do
      post :create, admins_merchant: {  }
    end

    assert_redirected_to admins_merchant_path(assigns(:admins_merchant))
  end

  test "should show admins_merchant" do
    get :show, id: @admins_merchant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admins_merchant
    assert_response :success
  end

  test "should update admins_merchant" do
    patch :update, id: @admins_merchant, admins_merchant: {  }
    assert_redirected_to admins_merchant_path(assigns(:admins_merchant))
  end

  test "should destroy admins_merchant" do
    assert_difference('Admins::Merchant.count', -1) do
      delete :destroy, id: @admins_merchant
    end

    assert_redirected_to admins_merchants_path
  end
end
