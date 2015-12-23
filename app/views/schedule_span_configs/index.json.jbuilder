json.array!(@schedule_span_configs) do |schedule_span_config|
  json.extract! schedule_span_config, :id, :owner_id, :owner_type, :name, :relative, :start_span_id, :finish_span_id, :start_time, :finish_time, :time_table, :reschedule_when_time_table_ends
  json.url schedule_span_config_url(schedule_span_config, format: :json)
end
