FactoryGirl.define do
  factory :route_provider do
    name "DummyProvider"
    provider_klass 'DummySmsProvider'
    options nil
    enabled true
    priority 1
    service_type "SMS"
  end
end
