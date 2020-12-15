# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "田中 実",
            email: "sample@example.com",
            password:              "foobar",
            password_confirmation: "foobar",
            admin: true)

99.times do |n|
 name  = Faker::Name.name
 email = "sample-#{n+1}@example.com"
 password = "password"
 User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password)

end

10.times do |n|
  Item.create!(name: Faker::Commerce.product_name,
               description: "冬に買いたくなる、身体が温まるアイテムです",
               point: "一家に一台必須",
               reference: "https://cookpad.com/recipe/2798655",
               recommend_degrees: 5,
               buy_memo: "初めて買ってよかった！",
               user_id: 1)
  item = Item.first
  Log.create!(item_id: item.id,
              content: item.buy_memo)
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }