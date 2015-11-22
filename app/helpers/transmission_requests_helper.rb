module TransmissionRequestsHelper
  def class_for_csv_column(header, options)
    classes = []
    if options.message_defined_at_column? and options.column_of_message == header
        classes << 'message-column'
    end

    if options.column_of_number == header
        classes << 'number-column'
    end

    if classes.size > 1
      classes << 'error-column'
    end
    classes.join(' ')
  end
end
