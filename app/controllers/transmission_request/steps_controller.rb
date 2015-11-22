class TransmissionRequest::StepsController < ApplicationController
  after_action :verify_authorized
  before_action :authenticate_user!
  include Wicked::Wizard
  steps( *TransmissionRequestCompositionService.steps)

  def show
    @transmission_request = safe_scope.find(params[:transmission_request_id])
    authorize @transmission_request

    if step == :parse
      @parse_type = @transmission_request.batch_file_type + '_parse'
    end
    render_wizard
  end

  def update
    @transmission_request = safe_scope.find(params[:transmission_request_id])
    authorize @transmission_request
    permitted_attributes = transmission_request_params(step)

    TransmissionRequestCompositionService.new.update(@transmission_request, step, permitted_attributes)

    case step.to_s
    when 'confirm'
      redirect_to transmission_requests_path, notice: 'Requisição criada com sucesso'
    else
      respond_to do |format|
        format.html {   render_wizard @transmission_request }
        format.js { render partial: 'batch_file'}
      end
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
                           when :parse
                             {:options => [:file_type] + parameters_for_file_type}
                           when :message
                             {:options => [:message_defined_at_column, :column_of_message, :custom_message, :column_of_number]}
                           when :schedule
                             {:options => [:schedule_finish_time, :schedule_start_time, :timing_table]}
                           when :confirm
                             return {}
                           end
    params.require(:transmission_request).permit(permitted_attributes)
  end

  def parameters_for_file_type
    type = params[:transmission_request][:options][:file_type]
    case type
    when 'csv'
      [:field_separator, :headers_at_first_line, :message_defined_at_column]
    else
      fail 'File type not allowed'
    end

  end
end
