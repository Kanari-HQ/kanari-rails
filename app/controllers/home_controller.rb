class HomeController < ApplicationController
  def index
    @events = Event.order("created_at DESC")
  end
end