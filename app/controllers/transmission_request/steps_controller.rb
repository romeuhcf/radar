require 'extensions/file'
class TransmissionRequestCompositionService
  def self.steps
    [ :upload, :parse, :message, :schedule, :confirm ]
  end

  def update(transmission_request, step, safe_params)
    case step
    when :confirm
      confirm(transmission_request)
    else
      update_attributes(transmission_request, safe_params)
        if step == :upload  # calculate csv options
          guessed_attributes = guess_attributes(transmission_request)
          update_attributes(transmission_request, guessed_attributes)
        end
    end
  end

  def confirm(transmission_request)
    transmission_request.status = 'processing'
    transmission_request.save! # TODO start the whole thing
  end

  def update_attributes(transmission_request, new_attributes)
    preexisting_options = transmission_request.options
    new_attributes[:options]||={}
    new_attributes[:options].reverse_merge!( preexisting_options )
    transmission_request.update(new_attributes)
  end

  def guess_attributes(transmission_request)
    send( 'guess_attributes_for_type_' + transmission_request.batch_file_type, transmission_request )
  end

  def available_fields(transmission_request)
    if transmission_request.batch_file_type == 'csv'
      ParsePreviewService.new.preview_csv(transmission_request, transmission_request.options)[:headers]
    else
      fail 'not implemented'
    end
  end

  def guess_attributes_for_type_csv(transmission_request)
    require 'csv_col_sep_sniffer'
    col_sep =  CsvColSepSniffer.find(transmission_request.batch_file.current_path)
    {:options => {file_type: 'csv', field_separator: col_sep }}
  end

  def estimate_number_of_messages(transmission_request)
    if transmission_request.batch_file_type == 'csv'
      nolines = File.wc_l(transmission_request.batch_file.current_path)
      if transmission_request.options['headers_at_first_line'] == '0' # TODO save headers_at_first_line as integer
        nolines
      else
        nolines - 1
      end
    else
      fail 'not implemented'
    end
  end

  def sample_message(transmission_request)
    if transmission_request.batch_file_type == 'csv'
      if transmission_request.options['message_defined_at_column'] != '0' # TODO make it boolean
        col = transmission_request.options['column_of_message']
        if transmission_request.options['headers_at_first_line'] == '0' # TODO save headers_at_first_line as integer
          col = col.to_i # TODO prepend cols with index to avoid zero indexed access
        end
        ParsePreviewService.new.preview_csv(transmission_request, transmission_request.options)[:rows].first[col]
      else
        transmission_request.options['custom_message']
      end
    else
      fail 'not implemented'
    end
  end
end

class TransmissionRequest::StepsController < ApplicationController
  before_action :authenticate_user!
  include Wicked::Wizard
  steps( *TransmissionRequestCompositionService.steps)

  def show
    @transmission_request = safe_scope.find(params[:transmission_request_id])

    if step == :parse
      @parse_type = @transmission_request.batch_file_type + '_parse'
    end
    render_wizard
  end

  def update
    @transmission_request = safe_scope.find(params[:transmission_request_id])
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
