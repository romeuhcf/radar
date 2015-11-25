class TransmissionRequestsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped
  before_action :authenticate_user!

  def index
    @transmission_requests = safe_scope.includes(:owner)

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

  def cancel
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request

    if policy(@transmission_request).destroy?
      @transmission_request.destroy
      real_destroy!
    else
      @transmission_request.cancel!
      redirect_to transmission_requests_path, notice: t("transmission_request.notify.cancel.success")
    end
  end

  def resume
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request
    @transmission_request.resume!
    redirect_to @transmission_request, notice: t("transmission_request.notify.resume.success")
  end

  def pause
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request
    @transmission_request.pause!
    redirect_to @transmission_request, notice: t("transmission_request.notify.pause.success")
  end

  def new
    @transmission_request = safe_scope.new
    authorize @transmission_request
  end

  def create
    @transmission_request = safe_scope.new(owner: current_owner, user: current_user, requested_via: 'web')

    authorize @transmission_request
    @transmission_request.save!(validate: false)
    redirect_to transmission_request_step_path(@transmission_request, 'upload')
  end

  def update
    @transmission_request = safe_scope.new(transmission_request_params)
    authorize @transmission_request

    @transmission_request.save
  end

  def parse_preview
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request

    @request_options = @transmission_request.options.merge( params[:transmission_request][:options].to_hash )
    @preview_data = ParsePreviewService.new.preview(@transmission_request, @request_options)

    view = ['transmission_requests','parse_preview', @transmission_request.batch_file_type].join('/')

    render view, layout: false
  end

  def destroy
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request
    real_destroy
  end

  protected

  def real_destroy!
    @transmission_request.destroy
    redirect_to transmission_requests_path, notice: t("transmission_request.notify.destroy.success")
  end

    def safe_scope
    policy_scope(TransmissionRequest)
  end

  def transmission_request_params
    params.require(:transmission_request).permit(:identification, :batch_file)
  end

end
