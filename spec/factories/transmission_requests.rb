FactoryGirl.define do
  factory :transmission_request do
    user { create(:user)}
    owner { create(:user)}
    identification Faker::Lorem.sentence
    requested_via "MyString"
    reference_date "2015-10-30"
    parse_config { create(:parse_config) }
    schedule_span_config { create(:schedule_span_config) }

    transient do
      size 5
    end

    after(:create) do |transmission_request, evaluator|
      create_list(:message, evaluator.size, transmission_request: transmission_request)
    end
  end
end
