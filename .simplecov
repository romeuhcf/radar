SimpleCov.start 'rails' do
  add_group "Services", "app/services"
  add_group "Workers", "app/workers"
  add_group "Generators", "app/generators"
  add_group "Providers", "app/providers"
end

