Kanari::Application.routes.draw do

  resources :events

  root 'home#index'

  resources :votes, only: [] do
    collection do
      get :vote
      post :create
    end
  end
end
