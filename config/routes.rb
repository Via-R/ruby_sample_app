Rails.application.routes.draw do
  get 'sessions/new'

	# [type of request] [path to show],  to: [controller]#[action], as: [prefered name of path variable]
  # get '/signup', to: 'users#new', as: "signup"
  get '/signup', to: 'users#new'

  post '/signup',  to: 'users#create'

  patch '/users/:id/edit(.:format)',  to: 'users#update'
  # patch '/users/:id(.:format)',  to: 'users#update'
  # Тут комментарий, потому что в случае ошибки формата формы обновления информации о странице новая форма открывается по адресу user/:id, а по логике должна в user/:id/edit

  get '/home', to: 'static_pages#home'

  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/contact', to: 'static_pages#contact'

	root 'static_pages#home'

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'
  
	resources :users
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
