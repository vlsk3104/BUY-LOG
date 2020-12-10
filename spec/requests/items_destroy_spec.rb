require "rails_helper"

RSpec.describe "アイテムの削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:item) { create(:item, user: user) }

  context "ログインしていて、自分のアイテムを削除する場合" do
    it "処理が成功し、トップページにリダイレクトすること" do
      login_for_request(user)
      expect {
        delete item_path(item)
      }.to change(Item, :count).by(-1)
      redirect_to user_path(user)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end

  context "ログインしていて、他人のアイテムを削除する場合" do
    it "処理が失敗し、トップページへリダイレクトすること" do
      login_for_request(other_user)
      expect {
        delete item_path(item)
      }.not_to change(Item, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      expect {
        delete item_path(item)
      }.not_to change(Item, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end