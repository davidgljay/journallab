Redcell::Application.routes.draw do


  match '/groups(/:urlname)/remove(/:u_id)', :to => 'groups#remove'
  match '/groups(/:urlname)/discuss(/:paper_id)', :to => 'groups#discuss'
  match '/groups/undiscuss(/:paper_id)', :to => 'groups#undiscuss'
  match '/groups(/:urlname)/join' , :to => 'groups#join'
  match '/groups(/:urlname)/leave' , :to => 'groups#leave'
  match '/groups(/:urlname)', :to => 'groups#show'
  match '/groups(/:urlname)/image', :to => 'groups#image_upload', :via => :put
  match '/groups(/:urlname)/image', :to => 'groups#remove_image', :via => :delete


  resources :filters
  resources :comments
  match '/comments(/:id)/reply',    :to => 'comments#reply'
  match 'comment_list',             :to => 'comments#list'


  resources :votes
  resources :shares
  match '/users(/:id)/sharefeed',	:to => 'shares#list'
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
  match '/lookup(/:search)', :to => 'papers#lookup'
  match '(/:about)(/:id)/discussion', :to => 'papers#discussion'
  match '/grab_images(/:id)', :to => 'papers#grab_images'
  match '/papers(/:id)/build_figs(/:num)', :to => 'papers#build_figs'
  match 'paper_show',               :to => 'papers#show'
  match '/papers(/:id)/m(/:m_id)', :to => 'papers#show_from_mail'
  match '/figs(/:id)/build_figsections(/:num)', :to => 'figs#build_sections'
  match '/figs(/:id)/image_upload', :to => 'figs#image_upload'
  match '/figs(/:id)/remove_image', :to => 'figs#remove_image', :via => :delete
  match '/pmid(/:pmid)', 			:to => 'papers#pmid'

  resources :follows
  match "/welcome",		:to => 'pages#welcome'
  match "/follows/remove(/:follow)", :to => 'follows#destroy'
  match "/follows(/:follow)/viewswitch(/:switchto)",       :to => 'follows#viewswitch'
  resources :reactions
  resources :notes
  resources :folders
  match '/folders(/:folder_id)/remove(/:paper_id)', :to => 'notes#destroy', :via => :delete
  match '/folders/add(/:pubmed_id)',	:to => 'folders#list'
  match 'quickform',			:to => 'reactions#quickform'
  match 'shares/new(/:pubmed_id)',		:to => 'shares#new'
  match 'medias',         :to => 'media#create', :via => :post
  match 'medias',         :to => 'media#index', :via => :get
  match '/medias/destroy(/:id)',         :to => 'media#destroy', :via => :delete

#Static pages


  root :to => 'pages#home'
  match '/var/1', :to => 'pages#var1'
  match '/about',    :to => 'pages#about'
  match '/dashboard',    :to => 'analysis#dashboard'
  match '/journals',  :to => 'analysis#journals'
  match '/most_discussed',  :to => 'analysis#most_discussed'
  match '/feedswitch(/:switchto)',	 :to => 'pages#feedswitch'
  match '/homeswitch', :to => 'pages#homeswitch'
  match '/sitemap.xml', :to => 'pages#sitemap'
  match '/report' , :to => 'pages#report'
  match '/manual_refresh', :to => 'pages#manual_refresh'


#Session routes
#resources :sessions, :only => [:new, :create, :destroy]
#  match '/signin',    :to => 'sessions#new'
#  match '/signout',   :to => 'sessions#destroy'

#Users routes

  devise_for :users
  resources :users
  match '/users(/:id)/history',	:to => 'users#history'
  match '/users(/:id)/subscriptions', :to => 'users#subscriptions', :via => :get
  match '/users(/:id)/subscriptions', :to => 'users#set_subscriptions', :via => :put



#  match '/reset_password', :to => 'users#reset_password'
#  match '/signup',   :to => 'users#new'
  match '/bulksignup', :to => 'users#bulk_new', :via => :get
  match '/bulksignup', :to => 'users#bulk_create', :via => :post
  match '/users(/:id)/unsubscribe', :to => 'users#unsubscribe'
  match '/users(/:id)/share_digest', :to => 'users#share_digest'
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
