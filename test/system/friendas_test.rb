require "application_system_test_case"

class FriendasTest < ApplicationSystemTestCase
  setup do
    @frienda = friendas(:one)
  end

  test "visiting the index" do
    visit friendas_url
    assert_selector "h1", text: "Friendas"
  end

  test "should create frienda" do
    visit friendas_url
    click_on "New frienda"

    fill_in "Email", with: @frienda.email
    fill_in "First name", with: @frienda.first_name
    fill_in "Last name", with: @frienda.last_name
    fill_in "Phone", with: @frienda.phone
    fill_in "Twitter", with: @frienda.twitter
    click_on "Create Frienda"

    assert_text "Frienda was successfully created"
    click_on "Back"
  end

  test "should update Frienda" do
    visit frienda_url(@frienda)
    click_on "Edit this frienda", match: :first

    fill_in "Email", with: @frienda.email
    fill_in "First name", with: @frienda.first_name
    fill_in "Last name", with: @frienda.last_name
    fill_in "Phone", with: @frienda.phone
    fill_in "Twitter", with: @frienda.twitter
    click_on "Update Frienda"

    assert_text "Frienda was successfully updated"
    click_on "Back"
  end

  test "should destroy Frienda" do
    visit frienda_url(@frienda)
    click_on "Destroy this frienda", match: :first

    assert_text "Frienda was successfully destroyed"
  end
end
