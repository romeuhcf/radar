json.array!(@api_clients) do |api_client|
  json.extract! api_client, :id, :owner_id, :owner_type, :secret_key, :last_used_at, :enabled, :description
  json.url api_client_url(api_client, format: :json)
end
