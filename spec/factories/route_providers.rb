FactoryGirl.define do
  factory :route_provider do
    name "MyString"
    provider_klass "String"
    options "MyString"
    enabled false
    priority false
    service_type "MyString"
  end

end
