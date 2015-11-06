source "https://rubygems.org"

gem "mysql2", "0.3.20"
gem "rails", "4.2.4"

# assets 
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "bootstrap-sass"
gem "slim-rails"
gem "simple_form"

# statistics
gem "chartkick"
gem "active_median"
gem "hightop"
gem "groupdate"

# queues
gem "sidekiq", "< 4"
gem "sidekiq-cron"
gem "sidekiq-limit_fetch"
gem "sinatra", :require => nil
gem "rest-client"
# static pages
gem "high_voltage"
gem 'figaro'

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  gem "factory_girl_rails"
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "simplecov", "~> 0.7.1", require: false
  gem "quiet_assets"
  gem "annotate_models"
  gem "faker"
  gem "vcr", require: false
  gem "webmock", require: false
  gem "selenium-webdriver", require: false
  gem "poltergeist", require: false
  gem "guard"
  gem "guard-rspec"
  gem "guard-bundler"
  gem "guard-rails"
end
# monitoring
gem "newrelic_rpm"

# pdf reporting
gem "pdfkit"
gem "wkhtmltopdf-binary-edge", "~> 0.12.2.1"

# authz
gem "devise"
gem "devise-async"

# admin 
gem "rails_admin"

gem "aasm"
gem 'phonelib'

group :development do
  gem "web-console", "~> 2.0"

  gem "devise-bootstrap-views"
  gem "devise-i18n-views"
end

#deployment
group :development do
  gem "capistrano", ">= 3.2.1"
  gem "capistrano-rvm"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano-sidekiq"
  gem "capistrano-passenger"
end


group :development do
  gem "thin"
  gem "rubocop", require: false
  gem "rails_best_practices", require: false
  gem "lol_dba", require: false
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end
