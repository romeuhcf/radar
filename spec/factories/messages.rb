FactoryGirl.define do
  factory :message do
    owner {create(:user)}
    media "MyString"
    weight ""
    transmission_state "processing"
    billable false
    scheduled_to { Time.current }
    sent_at nil
    transmission_request nil
    destination { create(:destination) }
    message_content do
      create(:message_content, (content ? {content: content}  : {} ) )
    end

    transient do
      content nil
    end

    trait :sent do
      sent_at {Time.current}
      transmission_state "sent"
    end
  end

end
