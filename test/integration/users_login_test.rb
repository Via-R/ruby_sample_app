require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "login with valid information followed by logout" do
    get login_path
    post '/login', params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    #Logging out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    #Logging out again in another tab (as well as cookies were deleted, and db remember_digest is nil, current_user will return nil, thus raising an error if not corrected)
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with invalid information" do
  	get login_path
  	assert_template 'sessions/new'
  	post '/login', params: { session: {email: "", password: ""}}
  	assert_template 'sessions/new'
  	assert_not flash.empty?
  	get home_path
  	assert flash.empty?
  end

  test "login with remembering" do
    # Log in to set the cookie
    log_in_as(@user)
    # Check whether the cookie is equal to the one user has
    assert_equal cookies[:remember_token], assigns(:user).remember_token  
  end

  test "login without remembering" do
    # Log in to set the cookie
    log_in_as(@user)
    # Log in again, this time without remembering the user
    log_in_as(@user, password: 'password', remember_me: '0')
    # Check whether the cookie corresponding to remembering the user is empty
    assert_empty cookies['remember_token']  
  end
end
