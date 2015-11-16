class TransmissionRequestsController < ApplicationController
  before_action :authenticate_user!
  def index
    @transmission_requests = scope.all # TODO paginate

    # Make users initally sorted by name ascending
    smart_listing_create :transmission_requests,
      @transmission_requests,
      partial: "transmission_requests/list",
      default_sort: {created_at: "desc"}
  end

  def show
    @transmission_request = scope.find(params[:id])
  end

  protected
  def scope
    # TODO authiruzation scope
    TransmissionRequest.all
  end
end
