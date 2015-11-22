FactoryGirl.define do
  factory :transmission_request do
    user { create(:user)}
    owner { create(:user)}
    identification Faker::Lorem.sentence
    requested_via "MyString"
    reference_date "2015-10-30"

    transient do
      size 5
    end

    after(:create) do |transmission_request, evaluator|
      create_list(:message, evaluator.size, transmission_request: transmission_request)
    end
  end
end
