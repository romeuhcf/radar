require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.ignore_localhost = true
  config.ignore_hosts '127.0.0.1', 'localhost', 'hooks.slack.com'
end

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
      VCR.use_cassette(name, options, &example)
    end
  end
end
