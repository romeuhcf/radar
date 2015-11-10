redis_options = Rails.configuration.database_configuration[Rails.env]['redis'].symbolize_keys
redis_options[:namespace] = [redis_options[:namespace], 'cache'].compact.join(':')
redis_options[:expires_in] = 90.minutes
Rails.application.config.cache_store = :redis_store, redis_options
