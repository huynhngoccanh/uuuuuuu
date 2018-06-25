require 'test_helper'

class Admins::CategoriesControllerTest < ActionController::TestCase
  setup do
    @admins_category = admins_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admins_category" do
    assert_difference('Admins::Category.count') do
      post :create, :admins_category => @admins_category.attributes
    end

    assert_redirected_to admins_category_path(assigns(:admins_category))
  end

  test "should show admins_category" do
    get :show, :id => @admins_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admins_category.to_param
    assert_response :success
  end

  test "should update admins_category" do
    put :update, :id => @admins_category.to_param, :admins_category => @admins_category.attributes
    assert_redirected_to admins_category_path(assigns(:admins_category))
  end

  test "should destroy admins_category" do
    assert_difference('Admins::Category.count', -1) do
      delete :destroy, :id => @admins_category.to_param
    end

    assert_redirected_to admins_categories_path
  end
end
