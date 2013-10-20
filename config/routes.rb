Kanari::Application.routes.draw do

  resources :events do
    collection do
      get :ajax_get_aggregate_votes
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
