json.array!(@ftp_configs) do |ftp_config|
  json.extract! ftp_config, :id, :owner_id, :owner_type, :host, :port, :user, :secret, :passive, :kind
  json.url ftp_config_url(ftp_config, format: :json)
end
