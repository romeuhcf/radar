class TransmissionRequest::StepsController < ApplicationController
  before_action :authenticate_user!
  include Wicked::Wizard
  steps :upload, :parse, :schedule, :confirm

  def show
    @transmission_request = safe_scope.find(params[:transmission_request_id])

    if step == :parse
      @parse_type = File.extname(@transmission_request.batch_file.current_path).gsub(/^\./, '') + '_parse'
    end

    render_wizard
  end

  def update
    @transmission_request = safe_scope.find(params[:transmission_request_id])
    @transmission_request.update(transmission_request_params(step))

    respond_to do |format|
      format.html {   render_wizard @transmission_request }
      format.js { render partial: 'batch_file'}
    end
  end

  protected
  def safe_scope
    TransmissionRequestPolicy::Scope.new(current_user, TransmissionRequest).resolve
  end

  def transmission_request_params(step)
    permitted_attributes = case step
                           when :upload
                             [:batch_file]
                           end

    params.require(:transmission_request).permit(permitted_attributes)
  end
end
