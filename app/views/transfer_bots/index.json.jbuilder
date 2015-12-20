json.array!(@transfer_bots) do |transfer_bot|
  json.extract! transfer_bot, :id, :description, :enabled, :cron, :server, :port, :user, :pwd, :passive, :remote_path, :patterns
  json.url transfer_bot_url(transfer_bot, format: :json)
end
