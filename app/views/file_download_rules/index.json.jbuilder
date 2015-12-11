json.array!(@file_download_rules) do |file_download_rule|
  json.extract! file_download_rule, :id, :description, :enabled, :cron, :server, :port, :user, :pwd, :passive, :remote_path, :patterns
  json.url file_download_rule_url(file_download_rule, format: :json)
end
