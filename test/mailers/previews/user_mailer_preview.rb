# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
  	# Тут мы передаём первого пользователя из базы данных, чтобы показать на нём как будет выглядеть письмо, высланное ему на почту
  	# Так как атрибута-токена нет в базе данных, поскольку он виртуальный, его нужно создать вручную
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
