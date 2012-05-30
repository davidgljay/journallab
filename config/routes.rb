Redcell::Application.routes.draw do
   
  get "follows/create"

  get "sumreq/create"

  get "figs/build_sections"

  resources :groups
   match '/groups(/:id)/remove(/:u_id)', :to => 'groups#remove'

  resources :filters
  resources :comments
   match '/comments(/:id)/reply',    :to => 'comments#reply'
   match 'comment_list',             :to => 'comments#list'
   match 'quickform',			:to => 'comments#quickform'

  resources :votes
  resources :shares
  resources :sumreqs


  resources :assertions
    match '/assertions/improve(/:id)', :to => 'assertions#improve'
    match '/assertions/new',           :to => 'assertions#new'
    match 'improve_list',             :to => 'assertions#list'


  resources :questions
   match '/questions(/:id)/answer',    :to => 'questions#answer'
   match '/questions(/:id)/comment',    :to => 'questions#comment'
   match 'question_list',             :to => 'questions#list'

  resources :authors

  resources :papers
   match '/lookup(/:pubmed_id)', :to => 'papers#lookup'
   match '(/:about)(/:id)/discussion', :to => 'papers#discussion'
   match '/grab_images(/:id)', :to => 'papers#grab_images'
   match '/papers(/:id)/build_figs(/:num)', :to => 'papers#build_figs'
   match 'paper_show',               :to => 'papers#show'
   match '/papers(/:id)/m(/:m_id)', :to => 'papers#show_from_mail'
   match '/figs(/:id)/build_figsections(/:num)', :to => 'figs#build_sections'
   match '/figs(/:id)/image_upload', :to => 'figs#image_upload'

  resources :follows

#Static pages

root :to => 'pages#home'
  match '/contact',  :to => 'pages#contact'
  match '/about',    :to => 'pages#about'
  match '/help',     :to => 'pages#help'
  match '/dashboard',    :to => 'pages#dashboard'
  match '/feedswitch(/:switchto)',	 :to => 'pages#feedswitch'




#Session routes
#resources :sessions, :only => [:new, :create, :destroy]
#  match '/signin',    :to => 'sessions#new'
#  match '/signout',   :to => 'sessions#destroy'

#Users routes

devise_for :users
resources :users


#  match '/reset_password', :to => 'users#reset_password'
#  match '/signup',   :to => 'users#new'
  match '/bulksignup', :to => 'users#bulk_new', :via => :get 
  match '/bulksignup', :to => 'users#bulk_create', :via => :post 
  match '/users(/:id)/unsubscribe', :to => 'users#unsubscribe'
  match '/users(/:id)/image_upload', :to => 'users#image_upload'

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
