require 'test_helper'

class Admin::MerchantsControllerTest < ActionController::TestCase
  setup do
    @admin_merchant = admin_merchants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_merchants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_merchant" do
    assert_difference('Admin::Merchant.count') do
      post :create, admin_merchant: {  }
    end

    assert_redirected_to admin_merchant_path(assigns(:admin_merchant))
  end

  test "should show admin_merchant" do
    get :show, id: @admin_merchant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_merchant
    assert_response :success
  end

  test "should update admin_merchant" do
    patch :update, id: @admin_merchant, admin_merchant: {  }
    assert_redirected_to admin_merchant_path(assigns(:admin_merchant))
  end

  test "should destroy admin_merchant" do
    assert_difference('Admin::Merchant.count', -1) do
      delete :destroy, id: @admin_merchant
    end

    assert_redirected_to admin_merchants_path
  end
end
