require "application_system_test_case"

class StoresTest < ApplicationSystemTestCase
  setup do
    @store = stores(:one)
  end

  test "visiting the index" do
    visit stores_url
    assert_selector "h1", text: "Stores"
  end

  test "should create store" do
    visit stores_url
    click_on "New store"

    fill_in "Admin user", with: @store.admin_user_id
    fill_in "Business name", with: @store.business_name
    fill_in "Email", with: @store.email
    fill_in "Ext number", with: @store.ext_number
    fill_in "Geolocation", with: @store.geolocation
    fill_in "Int number", with: @store.int_number
    fill_in "Name", with: @store.name
    fill_in "Rut", with: @store.rut
    fill_in "Status", with: @store.status
    fill_in "Street name", with: @store.street_name
    click_on "Create Store"

    assert_text "Store was successfully created"
    click_on "Back"
  end

  test "should update Store" do
    visit store_url(@store)
    click_on "Edit this store", match: :first

    fill_in "Admin user", with: @store.admin_user_id
    fill_in "Business name", with: @store.business_name
    fill_in "Email", with: @store.email
    fill_in "Ext number", with: @store.ext_number
    fill_in "Geolocation", with: @store.geolocation
    fill_in "Int number", with: @store.int_number
    fill_in "Name", with: @store.name
    fill_in "Rut", with: @store.rut
    fill_in "Status", with: @store.status
    fill_in "Street name", with: @store.street_name
    click_on "Update Store"

    assert_text "Store was successfully updated"
    click_on "Back"
  end

  test "should destroy Store" do
    visit store_url(@store)
    click_on "Destroy this store", match: :first

    assert_text "Store was successfully destroyed"
  end
end
