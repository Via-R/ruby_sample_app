class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #Добавляет функции из хелпера сессий (это по факту то, что написал я, а не какой-то левый пакет)
  include SessionsHelper
end
