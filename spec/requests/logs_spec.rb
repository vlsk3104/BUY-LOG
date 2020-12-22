require 'rails_helper'

RSpec.describe "ログ機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:item) { create(:item, user: user) }
  let!(:log) { create(:log, item: item) }

  context "ログ登録" do
    context "ログインしている場合" do
      context "アイテムを作成したユーザーである場合" do
        before do
          login_for_request(user)
        end

        it "有効なログが登録できること" do
          expect {
            post logs_path, params: { item_id: item.id,
                                      log: { content: "良い味付けで作れた" } }
          }.to change(item.logs, :count).by(1)
          expect(response).to redirect_to item_path(item)
        end

        it "無効なログが登録できないこと" do
          expect {
            post logs_path, params: { item_id: nil,
                                      log: { content: "良い味付けで作れた" } }
          }.not_to change(item.logs, :count)
        end
      end

      context "アイテムを作成したユーザーでない場合" do
        it "ログ登録できず、トップページへリダイレクトすること" do
          login_for_request(other_user)
          expect {
            post logs_path, params: { item_id: item.id,
                                      log: { content: "良い味付けで作れた" } }
          }.not_to change(item.logs, :count)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "ログインしていない場合" do
      it "ログ登録できず、ログインページへリダイレクトすること" do
        expect {
          post logs_path, params: { item_id: item.id,
                                    log: { content: "これは買い" } }
        }.not_to change(item.logs, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "ログ削除" do
    context "ログインしている場合" do
      context "ログを作成したユーザーである場合" do
        it "ログ削除ができること" do
          login_for_request(user)
          expect {
            delete log_path(log)
          }.to change(item.logs, :count).by(-1)
      end
    end

    context "ログを作成したユーザーでない場合" do
        it "ログ削除はできず、アイテム詳細ページへリダイレクトすること" do
          login_for_request(other_user)
          expect {
            delete log_path(log)
          }.not_to change(item.logs, :count)
          expect(response).to redirect_to item_path(item)
        end
      end
    end

    context "ログインしていない場合" do
      it "ログ削除はできず、ログインページへリダイレクトすること" do
        expect {
          delete log_path(log)
        }.not_to change(item.logs, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
