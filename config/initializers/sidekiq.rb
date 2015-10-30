redis_options = Rails.configuration.database_configuration[Rails.env]['redis'].symbolize_keys

Sidekiq.configure_server do |config|
  config.redis = redis_options
end

Sidekiq.configure_client do |config|
  config.redis = redis_options
end
