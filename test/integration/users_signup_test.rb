require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid user should not be saved" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path params: {
  			user: {
  				name: "",
  				email: "invalid@email",
  				password: "foo",
  				password_confirmation: "bar"
  			}
  		}
  	end

  	assert_template "users/new"
  	assert_select '#error_explanation'
  	assert_select '#error_explanation ul li', count: 4
    assert_select 'form[action="/signup"]'
  end

  # test "valid user should be saved" do
  #   get signup_path
  #   assert_difference 'User.count', 1 do
  #     post users_path params: {
  #       user:{
  #         name: "Test",
  #         email: "test@correct.com",
  #         password: "password",
  #         password_confirmation: "password"
  #       }
  #     }
  #   end
  #   follow_redirect!
  #   # assert_template 'users/show'
  #   # assert is_logged_in?
  # end

  test "new user should be greeted" do
    get signup_path
    post users_path params: {
      user:{
        name: "Test",
        email: "test@correct.com",
        password: "password",
        password_confirmation: "password"
      }
    }
    follow_redirect!
    # assert_template 'users/show'
    # assert_not flash.empty?
    # assert_select "div.alert-success"
  end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
