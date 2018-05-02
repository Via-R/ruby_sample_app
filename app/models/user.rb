class User < ApplicationRecord
	before_save   :downcase_email
  before_create :create_activation_digest
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  # И тут я нихрена не понял. Если регистрироваться, всё верно - эта валидация допускает пустые пароли, но их запрещает has_secure_password. А вот при редактировании
  # можно спокойно не вводить пароль, изменения сохраняются, но пароли почему-то не стают пустыми. МАГИЯ
	validates :password, presence: true, length:{minimum: 6}, allow_nil: true

	# Эта штуковина делает проверку чтобы совпадали пароли и чтобы они не были пустые
	has_secure_password

	# Returns the hash digest of the given string.
	#Этот метод прикреплён к самому классу, то есть можно юзать без конкретного юзера
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
  	SecureRandom.urlsafe_base64
  end

  #Этот метод привязан к конкретному пользователю, что логично, поскольку запоминать нужно именно определённого юзера, кроме того, этому юзеру приписывается сразу токен через аттрибут self
  attr_accessor :remember_token, :activation_token
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

   # Converts email to all lower-case.
    def downcase_email
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
