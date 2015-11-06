FactoryGirl.define do
  factory :route_provider do
    name "MyString"
    provider_klass 'DummySmsProvider'
    options "MyString"
    enabled true
    priority 1
    service_type "MyString"
  end

end
