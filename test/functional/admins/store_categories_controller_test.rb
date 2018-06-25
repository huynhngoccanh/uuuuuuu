require 'test_helper'

class Admins::StoreCategoriesControllerTest < ActionController::TestCase
  setup do
    @admins_store_category = admins_store_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins_store_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admins_store_category" do
    assert_difference('Admins::StoreCategory.count') do
      post :create, :admins_store_category => @admins_store_category.attributes
    end

    assert_redirected_to admins_store_category_path(assigns(:admins_store_category))
  end

  test "should show admins_store_category" do
    get :show, :id => @admins_store_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admins_store_category.to_param
    assert_response :success
  end

  test "should update admins_store_category" do
    put :update, :id => @admins_store_category.to_param, :admins_store_category => @admins_store_category.attributes
    assert_redirected_to admins_store_category_path(assigns(:admins_store_category))
  end

  test "should destroy admins_store_category" do
    assert_difference('Admins::StoreCategory.count', -1) do
      delete :destroy, :id => @admins_store_category.to_param
    end

    assert_redirected_to admins_store_categories_path
  end
end
