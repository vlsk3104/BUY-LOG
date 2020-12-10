require 'rails_helper'

RSpec.describe "アイテム登録", type: :request do
  let!(:user) { create(:user) }
  let!(:item) { create(:item, user: user) }

  context "ログインしているユーザーの場合" do
    before do
      get new_item_path
      login_for_request(user)
    end

    context "フレンドリーフォワーディング" do
      it "レスポンスが正常に表示されること" do
        expect(response).to redirect_to new_item_url
      end
    end

    it "有効なアイテムデータで登録できること" do
      expect {
        post items_path, params: { item: { name: "test",
                                           description: "冬に買いたくなる、身体が温まるアイテムです",
                                           point: "一家に一台必須",
                                           reference: "https://cookpad.com/recipe/2798655",
                                           recommend_degrees: 5 } }
      }.to change(Item, :count).by(1)
      follow_redirect!
      expect(response).to render_template('items/show')
    end

    it "無効なアイテムデータでは登録できないこと" do
      expect {
        post items_path, params: { item: { name: "",
                                           description: "冬に買いたくなる、身体が温まるアイテムです",
                                           point: "一家に一台必須",
                                           reference: "https://cookpad.com/recipe/2798655",
                                           recommend_degrees: 5 } }
      }.not_to change(Item, :count)
      expect(response).to render_template('items/new')
    end
  end


end
