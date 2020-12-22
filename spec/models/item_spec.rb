require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:item_yesterday) { create(:item, :yesterday) }
  let!(:item_one_week_ago) { create(:item, :one_week_ago) }
  let!(:item_one_month_ago) { create(:item, :one_month_ago) }
  let!(:item) { create(:item) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(item).to be_valid
    end

    it "名前がなければ無効な状態であること" do
      item = build(:item, name: nil)
      item.valid?
      expect(item.errors[:name]).to include("を入力してください")
    end

    it "名前が30文字以内であること" do
      item = build(:item, name: "あ" * 31)
      item.valid?
      expect(item.errors[:name]).to include("は30文字以内で入力してください")
    end

    it "説明が140文字以内であること" do
      item = build(:item, description: "あ" * 141)
      item.valid?
      expect(item.errors[:description]).to include("は140文字以内で入力してください")
    end

    it "ポイントが50文字以内であること" do
      item = build(:item, point: "あ" * 51)
      item.valid?
      expect(item.errors[:point]).to include("は50文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      item = build(:item, user_id: nil)
      item.valid?
      expect(item.errors[:user_id]).to include("を入力してください")
    end

    it "おすすめ度が1以上でなければ無効な状態であること" do
      item = build(:item, recommend_degrees: 0)
      item.valid?
      expect(item.errors[:recommend_degrees]).to include("は1以上の値にしてください")
    end

    it "人気度が5以下でなければ無効な状態であること" do
      item = build(:item, recommend_degrees: 6)
      item.valid?
      expect(item.errors[:recommend_degrees]).to include("は5以下の値にしてください")
    end
  end

  context "並び順" do
    it "最も最近の投稿が最初の投稿になっていること" do
      expect(item).to eq Item.first
    end
  end
end