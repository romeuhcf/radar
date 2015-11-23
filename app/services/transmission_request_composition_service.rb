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
    transmission_request.status = 'scheduled'
    transmission_request.save!
    process_start_time = if transmission_request.options.schedule_start_time - Time.current > 6.minutes
                           transmission_request.options.schedule_start_time - 5.minutes
                         else
                           transmission_request.options.schedule_start_time + 5.seconds
                         end
    TransmissionRequestProcessWorker.perform_at(process_start_time , transmission_request.id)
  end

  def update_attributes(transmission_request, new_attributes)
    new_attributes[:options] = transmission_request.options.merge(new_attributes[:options] || {} ).serializable_hash
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
    col_sep = CsvColSepSniffer.find(transmission_request.batch_file.current_path)
    {:options => {file_type: 'csv', field_separator: col_sep }}
  end

  def estimate_number_of_messages(transmission_request)
    if transmission_request.batch_file_type == 'csv'
      nolines = File.wc_l(transmission_request.batch_file.current_path)
      if transmission_request.options.headers_at_first_line?
        nolines - 1
      else
        nolines
      end
    else
      fail 'not implemented'
    end
  end

  def sample_message(transmission_request)
    if transmission_request.batch_file_type == 'csv'
      if transmission_request.options.message_defined_at_column?
        col = transmission_request.options.column_of_message
        preview_data = ParsePreviewService.new.preview_csv(transmission_request, transmission_request.options)
        first_row = preview_data.fetch(:rows).first
        first_row.fetch(col)
      else
        transmission_request.options.custom_message
      end
    else
      fail 'not implemented'
    end
  end
end
