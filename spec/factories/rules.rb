FactoryGirl.define do
  factory :rule do |r|
    r.sequence(:key) { |n| "key_#{n}" }
    value 0
  end
end
