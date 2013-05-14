CheechPool::Application.routes.draw do
  resources :users
  resources :leagues
  resources :sessions, only: [:new, :create, :destroy]
  resources :smacks,   only: [:create, :destroy]

  root to: 'static_pages#home'

  # Users
  match '/signup',    to: 'users#new'
  match '/users/:id/set_active_league/:league_id' => 'users#set_active_league', as: :set_active

  # Leagues
  match '/new_league', to: 'leagues#new'
  match '/leagues/:id/add_user' => 'leagues#add_user', as: :join
  match '/leagues/:id/remove_user' => 'leagues#remove_user', as: :quit
  match '/picksheet', to: 'leagues#picksheet'
  match '/picksheet/make_pre_picks' => 'leagues#make_pre_picks', as: :make_pre_picks
  match '/picksheet/make_picks' => 'leagues#make_picks', as: :make_picks
  match '/scoreboard', to: 'leagues#scoreboard'
  match '/admin',      to: 'leagues#admin'
  match '/admin/move_week' => 'leagues#move_week', as: :move_week
  match '/admin/finish_season' => 'leagues#finish_season', as: :finish_season
  match '/admin/close_picksheet' => 'leagues#close_picksheet', as: :close_picksheet

  # Sessions
  match '/signin',    to: 'sessions#new'
  match '/signout',   to: 'sessions#destroy', via: :delete

  # Static Pages
  match '/help',      to: 'static_pages#help'
  match '/about',     to: 'static_pages#about'
  match '/contact',   to: 'static_pages#contact'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
