ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.logout "/logout", :controller => "sessions", :action => "destroy"
  map.resources :assets, :collection=>{ :select_frame=>:get,
                                        :select_frame_ajax=>:post,
                                        :select_name_ajax=>:post,
                                        :select_font=>:get,
                                        :select_font_ajax=>:post,
                                        :select_matting=>:get,
                                        :select_bottom_matt_ajax=>:post,
                                        :select_top_matt_ajax=>:post,
                                        :select_ornament=>:get,
                                        :select_ornament_ajax=>:post,
                                        :upload_image=>:get,
                                        :checkout_ajax => :post,
                                        :swfupload=>:post,
                                        :saving_data=>:get,
                                        :get_text_dimensions=>:get,
                                        :get_flash_vars => :get,
                                        :gen_comp => :get,
                                        :get_mask => :get,
                                        :get_preview => :get,
                                        :get_uploaded_images => :get,
                                        :session_image_properties => :get,
                                        :update_html_frame => :get,
                                        :without_images => :get,
                                        :save_flex_image => :post
                                      }
  map.resource :session, :collection => [:login_by_token]
  map.checkout '/checkout',:controller=> "checkout", :action=> "checkout"
  map.order_completed '/order_completed', :controller => "orders", :action => "show_as_guest"
  map.about_us '/about_us',:controller=>"site", :action=>"about_us"
  map.media '/media',:controller=>"site", :action=>"media"
  map.contact '/contact',:controller=>"site", :action=>"contact"
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "site", :action=>"index"
  map.namespace :admin do |admin|
    # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
    admin.resources :privileged_task, :only => [:index, :destroy], :collection =>{:create_media_content => :post}
    admin.resources :users,
      :member => {:enable => :get, :disable => :get}
    admin.resources :orders, :collection => {:change_status => :post,:archive_order => :get,:filter=>[:post, :get], :orders_report => :get }
    admin.resources :order_codes, :except => [:show]
    admin.resource :session
    admin.logout "/logout", :controller => "sessions", :action => "destroy"
    admin.root :controller => "home", :action => "index"
  end

  map.resource :my_account, :only => [:index,:edit,:update, :show], :member => {:update => :post} do |my_account|
    my_account.resources :nameframes, :member => { :checkout => :get }
    my_account.resources :orders, :only => [:index , :show]
  end

  map.resources :nameframes, :only => [], :collection => {
                                                :get_session_cost => :get,
                                                :get_session_uploaded_images => :get,
                                                :get_session_enabled_to_upload => :get
                                              }
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

