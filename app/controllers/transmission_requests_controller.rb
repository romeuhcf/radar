class TransmissionRequestsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show, :destroy]
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

    @messages = smart_listing_create(:messages, @transmission_request.messages.joins(:destination, :message_content), partial: 'transmission_requests/messages')
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

  def create
    @transmission_request = safe_scope.new(owner: current_owner, user: current_user, requested_via: 'web')

    authorize @transmission_request
    @transmission_request.save!(validate: false)
    redirect_to transmission_request_step_path(@transmission_request, 'upload')
  end

  def parse_preview
    @transmission_request = safe_scope.find(params[:id])
    authorize @transmission_request

    current_parse_config_attribs = @transmission_request.parse_config.attributes
    updated_attribs = current_parse_config_attribs.merge( params[:transmission_request][:parse_config_attributes] )

    @request_parse_config = ParseConfig.new(updated_attribs)
    @preview_data = ParsePreviewService.new.preview(@transmission_request, @request_parse_config)

    view = ['transmission_requests','parse_preview', @transmission_request.batch_file_type].join('/')

    render view, layout: false
  end

  def destroy
    @transmission_request = safe_scope.find(params[:id])
    if policy(@transmission_request).destroy?
      @transmission_request.destroy
      real_destroy
    elsif policy(@transmission_request).cancel?
      @transmission_request.cancel!
      redirect_to transmission_requests_path, notice: t("transmission_request.notify.cancel.success")
    else
      redirect_to :back, notice: 'Permisison Denied'
    end
  end

  protected

  def real_destroy
    @transmission_request.destroy
    redirect_to transmission_requests_path, notice: t("transmission_request.notify.destroy.success")
  end

  def safe_scope
    policy_scope(TransmissionRequest)
  end

end
