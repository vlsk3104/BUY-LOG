FactoryBot.define do
  factory :favorite do
    association :item
    association :user
  end
end
