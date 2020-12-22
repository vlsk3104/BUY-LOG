FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "予想以上に熱いかもしれない。" }
    association :item
  end
end
