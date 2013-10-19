class VotesController < ApplicationController

  def vote
    @event  = Event.where(event_code: params[:event_code]).first
    @vote   = Vote.new
  end

  def create
    puts params
    @vote = Vote.new(vote_params)

    #respond_to do |format|
      if @vote.save
        #format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
        return render json: 'successfulz', status: :created  #, location: @vote }
      else
        #format.html { render action: 'new' }
        return render json: @vote.errors, status: :unprocessable_entity
      end
    #end
  end

  private

  def vote_params
    params.require(:vote).permit(:event_id, :vote_type)
  end
end