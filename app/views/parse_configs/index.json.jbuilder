json.array!(@parse_configs) do |parse_config|
  json.extract! parse_config, :id, :kind, :owner_id, :owner_type, :name, :message_defined_at_column, :column_of_message, :column_of_number, :column_of_destination_reference, :schedule_finish_time, :schedule_start_time, :timing_table, :field_separator, :headers_at_first_line, :custom_message, :skip_records
  json.url parse_config_url(parse_config, format: :json)
end
