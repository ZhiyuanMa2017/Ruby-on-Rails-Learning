require "test_helper"

class FriendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @frienda = friendas(:one)
  end

  test "should get index" do
    get friendas_url
    assert_response :success
  end

  test "should get new" do
    get new_frienda_url
    assert_response :success
  end

  test "should create frienda" do
    assert_difference("Frienda.count") do
      post friendas_url, params: { frienda: { email: @frienda.email, first_name: @frienda.first_name, last_name: @frienda.last_name, phone: @frienda.phone, twitter: @frienda.twitter } }
    end

    assert_redirected_to frienda_url(Frienda.last)
  end

  test "should show frienda" do
    get frienda_url(@frienda)
    assert_response :success
  end

  test "should get edit" do
    get edit_frienda_url(@frienda)
    assert_response :success
  end

  test "should update frienda" do
    patch frienda_url(@frienda), params: { frienda: { email: @frienda.email, first_name: @frienda.first_name, last_name: @frienda.last_name, phone: @frienda.phone, twitter: @frienda.twitter } }
    assert_redirected_to frienda_url(@frienda)
  end

  test "should destroy frienda" do
    assert_difference("Frienda.count", -1) do
      delete frienda_url(@frienda)
    end

    assert_redirected_to friendas_url
  end
end
