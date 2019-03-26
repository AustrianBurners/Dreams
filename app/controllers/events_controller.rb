class EventsController < ApplicationController
  def index
    @events = Event.all.order(start_at: :desc)
  end

  def show
    # TODO: We should provide an option on the events#show page to view
    # all past or future events, which will allow users to navigate to
    # events which are not the current one
    @event = Event.find(params[:id])
  end

  def current
    @event = Event.current
    render :show
  end

  def future
    @events = Event.future
    render :index
  end

  def past
    @events = Event.past
    render :index
  end

  def redirect_to_most_relevant
    redirect_to Event.most_relevant
  end
end
