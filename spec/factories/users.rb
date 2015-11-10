FactoryGirl.define do
  factory :user do
    email                  { Faker::Internet.email }
    password               "password"
    password_confirmation  "password"
  end

  factory :unconfirmed_user do
    email                  { Faker::Internet.email }
    password               "password"
    password_confirmation  "password"
  end

  factory :confirmed_user, class: 'User' do
    email                  { Faker::Internet.email }
    password               "password"
    password_confirmation  "password"
    confirmed_at           { 2.hours.ago }
  end
end
