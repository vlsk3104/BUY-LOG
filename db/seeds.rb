# ユーザー
User.create!(
  [
    {
      name:  "山田 智子",
      email: "yamada@example.com",
      password:              "foobar",
      password_confirmation: "foobar",
      admin: true,
    },
    {
      name:  "鈴木 英子",
      email: "suzuki@example.com",
      password:              "password",
      password_confirmation: "password",
    },
    {
      name:  "採用 太郎",
      email: "recruit@example.com",
      password:              "password",
      password_confirmation: "password",
    },
  ]
)

# フォロー関係
user1 = User.find(1)
user2 = User.find(2)
user3 = User.find(3)
user3.follow(user1)
user3.follow(user2)

# アイテム
description1 = "デザインがかわいいアイテムです。"
description2 = "コストパフォーマンスに優れたアイテム。"
description3 = "高性能で使いやすいアイテム！"
point1 = "今の時期安く買える！"
point2 = "オンライン限定モデル"
point3 = "家事の時間が減ること間違いなし！"
buy_memo1 = "プレゼント用で購入"
buy_memo2 = "保証が1年間"
buy_memo3 = "人気すぎて在庫がほとんどなさそう"

## 3ユーザー、それぞれ5アイテムずつ作成
Item.create!(
  [
    {
      name: "AKIRA",
      user_id: 1,
      description: description2,
      point: point1,
      reference: "https://www.mercari.com/jp/",
      recommend_degrees: 3,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item1.jpg"),
      genres_attributes: [
                                { name: "本"},
                                { name: "マンガ"},
                                { name: "アニメ"},
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "ドラム型洗濯機",
      user_id: 2,
      description: description3,
      point: point3,
      reference: "https://www.biccamera.com/bc/main/",
      recommend_degrees: 4,
      buy_memo: buy_memo2,
      picture: open("#{Rails.root}/public/images/item2.jpg"),
      genres_attributes: [
                                { name: "家電" },
                                { name: "洗濯機" },
                                { name: "ドラム型" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "椅子",
      user_id: 3,
      description: description1,
      point: point2,
      reference: "https://www.ikea.com/jp/ja/",
      recommend_degrees: 4,
      buy_memo: buy_memo1,
      picture: open("#{Rails.root}/public/images/item3.jpg"),
      genres_attributes: [
                                { name: "イス" },
                                { name: "家具" },
                                { name: "インテリア" },
                                { name: "白"},
                                { name: "" }
                              ],
    },
    {
      name: "バック",
      user_id: 1,
      description: description1,
      point: point2,
      reference: "https://www.amazon.co.jp/",
      recommend_degrees: 3,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item4.jpg"),
      genres_attributes: [
                                { name: "オレンジ" },
                                { name: "リュック" },
                                { name: "ブランド" },
                                { name: "レディース" },
                                { name: "" }
                              ],
    },
    {
      name: "apple watch",
      user_id: 2,
      description: description3,
      point: point1,
      reference: "https://www.apple.com/jp/",
      recommend_degrees: 2,
      buy_memo: buy_memo1,
      picture: open("#{Rails.root}/public/images/item5.jpg"),
      genres_attributes: [
                                { name: "apple" },
                                { name: "時計" },
                                { name: "黒" },
                                { name: "" },
                                { name: ""}
                              ],
    },
    {
      name: "ドライヤー",
      user_id: 3,
      description: description3,
      point: point3,
      reference: "https://www.rakuten.co.jp/",
      recommend_degrees: 2,
      buy_memo: buy_memo2,
      picture: open("#{Rails.root}/public/images/item6.jpg"),
      genres_attributes: [
                                { name: "ドライヤー" },
                                { name: "ブランド" },
                                { name: "黒" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "airpods pro",
      user_id: 1,
      description: description3,
      point: point1,
      reference: "https://www.apple.com/jp/",
      recommend_degrees: 5,
      buy_memo: buy_memo2,
      picture: open("#{Rails.root}/public/images/item7.jpg"),
      genres_attributes: [
                                { name: "apple" },
                                { name: "イヤホン" },
                                { name: "ワイヤレス" },
                                { name: "白" },
                                { name: "" }
                              ],
    },
    {
      name: "バックパック",
      user_id: 2,
      description: description1,
      point: point2,
      reference: "https://shopping.yahoo.co.jp/",
      recommend_degrees: 4,
      buy_memo: buy_memo1,
      picture: open("#{Rails.root}/public/images/item8.jpg"),
      genres_attributes: [
                                { name: "バック" },
                                { name: "黒" },
                                { name: "メンズ" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "ハリーポッター",
      user_id: 3,
      description: description2,
      point: point1,
      reference: "https://www.junkudo.co.jp/",
      recommend_degrees: 5,
      buy_memo: buy_memo1,
      picture: open("#{Rails.root}/public/images/item9.jpg"),
      genres_attributes: [
                                { name: "USJ" },
                                { name: "映画" },
                                { name: "本" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "スニーカー",
      user_id: 1,
      description: description2,
      point: point2,
      reference: "https://zozo.jp/",
      recommend_degrees: 5,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item10.jpg"),
      genres_attributes: [
                                { name: "ピンク" },
                                { name: "レディース" },
                                { name: "ニューバランス" },
                                { name: "靴" },
                                { name: "" }
                              ],
    },
    {
      name: "mac book air",
      user_id: 2,
      description: description3,
      point: point1,
      reference: "https://www.apple.com/jp/",
      recommend_degrees: 3,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item11.jpg"),
      genres_attributes: [
                                { name: "apple" },
                                { name: "PC" },
                                { name: "グレー" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "シューズ",
      user_id: 3,
      description: description2,
      point: point1,
      reference: "https://www.abc-mart.net/shop/",
      recommend_degrees: 4,
      buy_memo: buy_memo2,
      picture: open("#{Rails.root}/public/images/item12.jpg"),
      genres_attributes: [
                                { name: "黒" },
                                { name: "靴" },
                                { name: "メンズ" },
                                { name: "コンバース" },
                                { name: "" }
                              ],
    },
    {
      name: "ソファ",
      user_id: 1,
      description: description1,
      point: point2,
      reference: "https://www.nitori-net.jp/ec/",
      recommend_degrees: 5,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item13.jpg"),
      genres_attributes: [
                                { name: "家具"},
                                { name: "インテリア" },
                                { name: "緑" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "ロボット掃除機",
      user_id: 2,
      description: description1,
      point: point3,
      reference: "https://www.irobot-jp.com/roomba/",
      recommend_degrees: 4,
      buy_memo: buy_memo2,
      picture: open("#{Rails.root}/public/images/item14.jpg"),
      genres_attributes: [
                                { name: "家電" },
                                { name: "黒" },
                                { name: "ルンバ" },
                                { name: "" },
                                { name: "" }
                              ],
    },
    {
      name: "ミニオンのフィギュア",
      user_id: 3,
      description: description1,
      point: point1,
      reference: "https://www.usj.co.jp/web/ja/jp",
      recommend_degrees: 5,
      buy_memo: buy_memo3,
      picture: open("#{Rails.root}/public/images/item15.jpg"),
      genres_attributes: [
                                { name: "USJ" },
                                { name: "キャラクター" },
                                { name: "おもちゃ" },
                                { name: "映画" },
                                { name: "" }
                              ],
    }
  ]
)

item3 = Item.find(3)
item6 = Item.find(6)
item12 = Item.find(12)
item13 = Item.find(13)
item14 = Item.find(14)
item15 = Item.find(15)

# お気に入り登録
user3.favorite(item13)
user3.favorite(item14)
user1.favorite(item15)
user2.favorite(item12)

# コメント
item15.comments.create(user_id: user1.id, content: "いいな！私も欲しい！")
item12.comments.create(user_id: user2.id, content: "デザインいいな〜")

# 通知
user3.notifications.create(user_id: user3.id, item_id: item15.id,
                           from_user_id: user1.id, variety: 1)
user3.notifications.create(user_id: user3.id, item_id: item15.id,
                           from_user_id: user1.id, variety: 2, content: "いいな！私も欲しい！")
user3.notifications.create(user_id: user3.id, item_id: item12.id,
                           from_user_id: user2.id, variety: 1)
user3.notifications.create(user_id: user3.id, item_id: item12.id,
                           from_user_id: user2.id, variety: 2, content: "デザインいいな〜")
# リスト
user3.list(item3)
user1.list(item15)
user3.list(item6)
user2.list(item12)

# ログ
Item.all.each do |item|
  Log.create!(item_id: item.id,
              content: item.buy_memo)
end