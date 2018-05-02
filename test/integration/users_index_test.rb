require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @not_activated = users(:dork)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name unless user == @not_activated
      unless user == @admin or user == @not_activated
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "not activated users shouldn't appear in the list" do
    log_in_as(@non_admin)
    get users_path
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert user.activated unless user == @not_activated
    end
  end

  test "not activated users shouldn't have their profiles visible via direct link" do
    get user_path(@not_activated)
    follow_redirect!
    assert_template root_path
    log_in_as(@not_activated)
    get user_path(@not_activated)
    follow_redirect!
    assert_template root_path
  end
end