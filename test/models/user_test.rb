require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@def_user = User.new ({ name: "Dummy", email: "dummy@mail.com", password: "foobar", password_confirmation: "foobar" })
	end

	test "should be valid"  do
		assert @def_user.valid?		
	end

	test "name should be present" do
		@def_user.name = "    "
		assert_not @def_user.valid?
	end

	test "email should be present" do
		@def_user.email = "    "
		assert_not @def_user.valid?
	end

	test "name should not be too long" do
		@def_user.name = "n" * 51
		assert_not @def_user.valid?
	end

	test "email should not be too long" do
		@def_user.email = "e" * 247 + "@mail.com"
		assert_not @def_user.valid?
	end

	test "email should accept valid addresses" do
		val_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		val_emails.each do |w|
			@def_user.email = w
			assert @def_user.valid?, "#{w.inspect} should be valid!"			
		end
	end

	test "email should reject invalid addresses" do
		inval_emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
		inval_emails.each do |w|
			@def_user.email = w
			assert_not @def_user.valid?, "#{w.inspect} should be invalid!"			
		end
	end

	test "email should be unique" do
		dupl = @def_user.dup
		dupl.email.upcase!
		@def_user.save
		assert_not dupl.valid?
	end
	
	test "email should be saved as lower-case" do
		mixed_case_email = "FoO@Bar.NeT"
		@def_user.email = mixed_case_email
		@def_user.save
		assert_equal mixed_case_email.downcase, @def_user.reload.email
	end

	test "password should not be too short" do 
		@def_user.password = @def_user.password_confirmation = "p" * 5
		assert_not @def_user.valid?
	end

	test "password should not be blank" do 
		@def_user.password = @def_user.password_confirmation = " " * 6
		assert_not @def_user.valid?
	end
  # test "the truth" do
  #   assert true
  # end
end
