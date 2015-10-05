Rails.application.routes.draw do

  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  root to: 'static_pages#home'
  mount Forem::Engine, :at => '/forems'

  devise_for :users

  resources :categories, :only => [:index, :show]

  get '/:forum_id/moderation', :to => "moderation#index", :as => :forum_moderator_tools
  # For mass moderation of posts
  put '/:forum_id/moderate/posts', :to => "moderation#posts", :as => :forum_moderate_posts
  # Moderation of a single topic
  put '/:forum_id/topics/:topic_id/moderate', :to => "moderation#topic", :as => :moderate_forum_topic

  resources :forums, :only => [:index, :show] do
    resources :topics, :except => :index do
      resources :posts, :except => :index
      member do
        post :subscribe
        post :unsubscribe
      end
    end
  end
end
