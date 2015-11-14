FactoryGirl.define do
  factory :chat_room do
    owner nil
    destination { create(:destination) }
    answered true
    archived false
  end
end
