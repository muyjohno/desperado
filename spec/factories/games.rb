FactoryGirl.define do
  factory :game do
    association :corp, factory: :player
    association :runner, factory: :player
    result :corp_win
    week 1
  end
end
