json.array!(@ftp_configurations) do |ftp_configuration|
  json.extract! ftp_configuration, :id, :owner_id, :owner_type, :host, :port, :user, :secret, :passive, :kind
  json.url ftp_configuration_url(ftp_configuration, format: :json)
end
