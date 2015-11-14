FactoryGirl.define do
  factory :destination do
    kind 'MOBILE'
    address { ['55', 1 + rand(8), 1 + rand(8), '9', 60000000 + rand(40000000)].join() }
    contacted_times 1
    last_used_at "2015-10-30"
  end
end
