FactoryGirl.define do
  factory :game do
    association :corp, factory: :player
    association :runner, factory: :player
    result 1
  end
end
