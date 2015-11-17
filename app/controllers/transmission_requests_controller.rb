class TransmissionRequestsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped
  before_action :authenticate_user!
  #include Wicked::Wizard
  #steps :batch_file, :parsing, :preview, :schedule, :confirmation

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

    render_wizard
  end

  def new
    @transmission_request = safe_scope.new
    authorize @transmission_request
  end

  def create
    @transmission_request = safe_scope.new
    authorize @transmission_request
  end

  def update
    @transmission_request = safe_scope.new(transmission_request_params)
    authorize @transmission_request

    @transmission_request.save
  end

  protected
  def safe_scope
    policy_scope(TransmissionRequest)
  end

  def transmission_request_params
    params.require(:transmission_request).permit(:identification, :batch_file)
  end
end
