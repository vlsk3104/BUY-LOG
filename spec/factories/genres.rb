FactoryBot.define do
  factory :genre do
    name { "スマホ" }
    association :item
  end
end
