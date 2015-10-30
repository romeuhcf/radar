source 'https://rubygems.org'

gem 'mysql2', '0.3.20'
gem 'rails', '4.2.4'

# assets 
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'bootstrap-sass'


# statistics
gem "chartkick"
gem "active_median"
gem "hightop"
gem 'groupdate'

# queues
gem "sidekiq", '< 4'
gem 'sidekiq-cron'
gem 'sidekiq-limit_fetch'

# static pages
gem 'high_voltage'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'thin'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'simplecov', '~> 0.7.1', require: false
  gem 'faker'
  gem 'quiet_assets'
end

# monitoring
gem 'newrelic_rpm'

# pdf reporting
gem 'pdfkit'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.2.1'



# authz
gem 'devise'

# admin 
gem 'rails_admin'

group :development do
  gem 'web-console', '~> 2.0'
end

#deployment
group :development do
  gem 'capistrano', '>= 3.2.1'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
end


group :development do
  gem 'rubocop'
  gem 'rails_best_practices'
  gem 'lol_dba'
  gem 'brakeman'
  gem 'bundler-audit'
end
