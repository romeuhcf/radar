class TransmissionRequest::StepsController < ApplicationController
  before_action :authenticate_user!
  include Wicked::Wizard
  steps :upload, :parse, :message, :schedule, :confirm

  def show
    @transmission_request = safe_scope.find(params[:transmission_request_id])

    if step == :parse
      @parse_type = File.extname(@transmission_request.batch_file.current_path).gsub(/^\./, '') + '_parse'
    end
    render_wizard
  end

  def update
    @transmission_request = safe_scope.find(params[:transmission_request_id])
    if step.to_s == 'confirm'
      @transmission_request.status = 'processing'
      @transmission_request.save! # TODO start the whole thing
      redirect_to transmission_requests_path, notice: 'Requisição criada com sucesso'
    else
      new_attributes = transmission_request_params(step)
      new_attributes[:options]||={}
      new_attributes[:options].reverse_merge!(@transmission_request.options || {})
      @transmission_request.update(new_attributes)

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
                             {:options => [:message_defined_at_column, :column_of_message]}
                           when :schedule
                             {:options => [:schedule_finish_time, :schedule_start_time, :timing_table]}
                           end
    params.require(:transmission_request).permit(permitted_attributes)
  end

  def parameters_for_file_type
    type = params[:transmission_request][:options][:file_type]
    case type
    when 'csv'
      [:field_separator, :headers_at_first_line, :message_defined_at_column, :column_of_message]
    else
      fail 'File type not allowed'
    end

  end
end
