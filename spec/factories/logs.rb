FactoryBot.define do
  factory :log do
    content { "近くのショップに売ってるかも" }
    association :item
  end
end