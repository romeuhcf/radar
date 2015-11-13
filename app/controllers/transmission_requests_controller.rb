class TransmissionRequestsController < ApplicationController
  before_action :authenticate_user!
  def index
    @transmission_requests = scope.all # TODO paginate
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
