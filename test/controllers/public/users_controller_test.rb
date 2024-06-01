require "test_helper"

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get mypage" do
    get public_users_mypage_url
    assert_response :success
  end

  test "should get confirm" do
    get public_users_confirm_url
    assert_response :success
  end

  test "should get close_acount" do
    get public_users_close_acount_url
    assert_response :success
  end

  test "should get show" do
    get public_users_show_url
    assert_response :success
  end
end
