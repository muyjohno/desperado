FactoryGirl.define do
  factory :earned_achievement do
    association :player
    association :game
    association :achievement
  end
end
