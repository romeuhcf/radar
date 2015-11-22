module TransmissionRequestsHelper
  def class_for_csv_column(header, options)
    classes = []
    if options['message_defined_at_column'] == '1' # TODO real boolean
      if options['column_of_message'] == header.to_s
        classes << 'message-column'
      end
    end

    if options['column_of_number'] == header.to_s
        classes << 'number-column'
    end

    if classes.size > 1
      classes << 'error-column'
    end
    classes.join(' ')
  end
end
