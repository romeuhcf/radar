if ENV['CI'] == 'codeship'
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
end
