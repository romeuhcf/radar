require 'extensions/file'
class TransmissionRequestCompositionService
  attr_reader :transmission_request
  attr_accessor :step
  def initialize(transmission_request)
    @transmission_request = transmission_request
  end

  def self.steps
    [ :upload, :parse, :message, :schedule, :confirm ]
  end

  def update(step, safe_params)
    case step
    when :confirm
      confirm
    else
      update_attributes(safe_params)
      if step == :upload  # calculate csv options
        update_attributes(guess_attributes)
      end
    end
  end

  def confirm
    transmission_request.status = 'scheduled'
    transmission_request.save!
    process_start_time = if transmission_request.options.schedule_start_time - Time.current > 6.minutes
                           transmission_request.options.schedule_start_time - 5.minutes
                         else
                           transmission_request.options.schedule_start_time + 5.seconds
                         end

    Sidekiq::Client.enqueue_to_in("owner-#{transmission_request.owner_id}-transmission-request", process_start_time - Time.zone.now , TransmissionRequestProcessWorker, transmission_request.id)
  end

  def can_step_to?(step)
    return true if step == :upload
    return false unless transmission_request.batch_file.current_path
    return false if step == :confirm && !valid_composition?
    return true
  end

  def valid_composition?
    transmission_request.options.column_of_number &&
      (transmission_request.options.column_of_message ||
       transmission_request.options.custom_message ) &&
      sample_message &&
      transmission_request.options.timing_table
  end

  def update_attributes(new_attributes)
    new_attributes[:options] = transmission_request.options.merge(new_attributes[:options] || {} ).serializable_hash
    transmission_request.update(new_attributes)
  end

  def guess_attributes
    send( 'guess_attributes_for_type_' + transmission_request.batch_file_type)
  end

  def available_fields
    if transmission_request.batch_file_type == 'csv'
      ParsePreviewService.new.preview_csv(transmission_request, transmission_request.options)[:headers]
    else
      fail 'not implemented'
    end
  end

  def guess_attributes_for_type_csv
    require 'csv_col_sep_sniffer'
    col_sep = CsvColSepSniffer.find(transmission_request.batch_file.current_path)
    {:options => {file_type: 'csv', field_separator: col_sep }}
  end

  def estimate_number_of_messages
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

  def sample_message
    generator_service = BatchFileGeneratorsService.new(transmission_request)

    generator_service     = BatchFileGeneratorsService.new(transmission_request)
    content_generator     = generator_service.content_generator
    destination_generator = generator_service.destination_generator
    schedule_generator    = generator_service.schedule_generator

    destination_data = nil
    destination_generator.generate(1) {|dd| destination_data = dd }
    content_generator.generate(destination_data)

  end
end
