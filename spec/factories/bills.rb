FactoryGirl.define do
  factory :bill do
    customer nil
    reference_date_begin "2015-10-30"
    reference_date_end "2015-10-30"
    grand_total "9.99"
    paid false
    due_to "2015-10-30"
  end
end
