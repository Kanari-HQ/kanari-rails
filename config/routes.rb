Kanari::Application.routes.draw do

  resources :events do
    collection do
      get  :ajax_get_aggregate_votes
      post :ajax_set_event_time
    end
  end

  root 'home#index'

  resources :votes, only: [] do
    collection do
      get :vote
      post :create
    end
  end
end
