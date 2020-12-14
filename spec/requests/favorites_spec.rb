require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  context "お気に入り一覧ページの表示" do
    context "ログインしている場合" do
      it "レスポンスが正常に表示されること" do
        login_for_request(user)
        get favorites_path
        expect(response).to have_http_status "200"
        expect(response).to render_template('favorites/index')
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトすること" do
        get favorites_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end

  context "お気に入り登録処理" do
     context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "アイテムのお気に入り登録ができること" do
        expect {
          post "/favorites/#{item.id}/create"
        }.to change(user.favorites, :count).by(1)
      end

      it "アイテムのAjaxによるお気に入り登録ができること" do
        expect {
          post "/favorites/#{item.id}/create", xhr: true
        }.to change(user.favorites, :count).by(1)
      end

      it "アイテムのお気に入り解除ができること" do
        user.favorite(item)
        expect {
          delete "/favorites/#{item.id}/destroy"
        }.to change(user.favorites, :count).by(-1)
      end

      it "アイテムのAjaxによるお気に入り解除ができること" do
        user.favorite(item)
        expect {
          delete "/favorites/#{item.id}/destroy", xhr: true
        }.to change(user.favorites, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "お気に入り登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/favorites/#{item.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it "お気に入り解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/favorites/#{item.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end