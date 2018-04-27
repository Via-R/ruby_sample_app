require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "users list and account settings shouldn't appear when not logged in" do
    get root_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(user_path(@user)), count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", login_path, count: 1
  end

  test "users list and account settings should appear when logged in" do
    log_in_as @user
    get root_path
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
    assert_select "a[href=?]", edit_user_path(@user), count: 1
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", login_path, count: 0
  end
  # test "the truth" do
  #   assert true
  # end
end
