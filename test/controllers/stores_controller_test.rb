require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @store = stores(:one)
  end

  test "should get index" do
    get stores_url
    assert_response :success
  end

  test "should get new" do
    get new_store_url
    assert_response :success
  end

  test "should create store" do
    assert_difference("Store.count") do
      post stores_url, params: { store: { admin_user_id: @store.admin_user_id, business_name: @store.business_name, email: @store.email, ext_number: @store.ext_number, geolocation: @store.geolocation, int_number: @store.int_number, name: @store.name, rut: @store.rut, status: @store.status, street_name: @store.street_name } }
    end

    assert_redirected_to store_url(Store.last)
  end

  test "should show store" do
    get store_url(@store)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_url(@store)
    assert_response :success
  end

  test "should update store" do
    patch store_url(@store), params: { store: { admin_user_id: @store.admin_user_id, business_name: @store.business_name, email: @store.email, ext_number: @store.ext_number, geolocation: @store.geolocation, int_number: @store.int_number, name: @store.name, rut: @store.rut, status: @store.status, street_name: @store.street_name } }
    assert_redirected_to store_url(@store)
  end

  test "should destroy store" do
    assert_difference("Store.count", -1) do
      delete store_url(@store)
    end

    assert_redirected_to stores_url
  end
end
