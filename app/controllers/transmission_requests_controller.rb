class TransmissionRequestsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped

  before_action :authenticate_user!
  def index
    @transmission_requests = safe_scope

    # Make users initally sorted by name ascending
    smart_listing_create :transmission_requests,
      @transmission_requests,
      partial: "transmission_requests/list",
      default_sort: {created_at: "desc"}
  end

  def show
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request
  end

  protected
  def safe_scope
    policy_scope(TransmissionRequest)
  end
end
