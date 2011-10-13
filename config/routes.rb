Redcell::Application.routes.draw do
   
  resources :groups

  resources :filters
  resources :comments
   match '/comments(/:id)/reply',    :to => 'comments#reply'
   match 'comment_list',             :to => 'comments#list'

  resources :votes

  resources :assertions
    match '/assertions/improve(/:id)', :to => 'assertions#improve'

  resources :questions
   match '/questions(/:id)/answer',    :to => 'questions#answer'
   match '/questions(/:id)/comment',    :to => 'questions#comment'
   match 'question_list',             :to => 'questions#list'

  resources :authors

  resources :papers
   match '/lookup(/:pubmed_id)', :to => 'papers#lookup'
   match '(/:about)(/:id)/discussion', :to => 'papers#discussion'
   match '/grab_images(/:id)', :to => 'papers#grab_images'

#Micropost routes
resources :microposts, :only => [:create, :destroy]

#Static pages

root :to => 'pages#home'
  match '/contact',  :to => 'pages#contact'
  match '/about',    :to => 'pages#about'
  match '/help',     :to => 'pages#help'




#Session routes
resources :sessions, :only => [:new, :create, :destroy]
  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'

#Users routes

resources :users do
   member do
     get :following, :followers
   end
 end

  match '/signup',   :to => 'users#new'

#Relationship routes

resources :relationships, :only => [:create, :destroy]

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
