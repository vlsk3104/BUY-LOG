FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { "冬に買いたくなる、身体が温まるアイテムです" }
    point { "一家に一台必須" }
    reference { "https://cookpad.com/recipe/2798655" }
    recommend_degrees { 5 }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end
