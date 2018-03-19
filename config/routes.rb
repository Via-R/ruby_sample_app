Rails.application.routes.draw do
	# [type of request] [path to show],  to: [controller]#[action], as: [prefered name of path variable]
  # get '/signup', to: 'users#new', as: "signup"
  get '/signup', to: 'users#new'

	post '/signup',  to: 'users#create'

  get '/home', to: 'static_pages#home'

  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/contact', to: 'static_pages#contact'

	root 'static_pages#home'

	resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
