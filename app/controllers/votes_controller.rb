class VotesController < ApplicationController

  def vote
    @event_code = params[:event_code]
    @event      = Event.where(event_code: params[:event_code]).first
    @vote       = Vote.new
  end

  def create
    puts params
    @vote = Vote.new(vote_params)

    if @vote.save
      head :ok
    else
      return render json: @vote.errors, status: :unprocessable_entity
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:event_id, :vote_type)
  end
end