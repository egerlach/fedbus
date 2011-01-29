Ticketing::Application.routes.draw do 
#	map.resources :reading_weeks
  
 # map.connect 'buses/today.:format', :controller => 'buses', :action => 'today'


#  map.resources :blackouts
#  map.resources :holidays
#  map.resources :trips
#  map.resources :buses
#  map.resources :permissions
#  map.resources :roles
#  map.resources :users
#  map.resources :admin

	resources :reading_weeks, :blackouts, :holidays, :trips, :buses,
	          :permissions, :roles, :users
	resource :admin

	match 'buses/today.:format', :to => 'buses#today'

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
  # root :to => "welcome#index"
  #map.root :controller => :users
	root :to => 'users#index'

  # See how all your routes lay out with "rake routes"
  #map.login '/login', :controller => :users, :action => :login
  #map.logout '/logout', :controller => :users, :action => :logout
	match 'login', :to => 'users#login', :as => "login"
	match 'logout', :to => 'users#logout', :as => "logout"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
