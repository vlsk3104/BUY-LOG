require "rails_helper"

RSpec.describe "アイテム編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:item) { create(:item, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_item2.jpg') }  
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) } 

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること(+フレンドリーフォワーディング)" do
      get edit_item_path(item)
      login_for_request(user)
      expect(response).to redirect_to edit_item_url(item)
      patch item_path(item), params: { item: { name: "test",
                                               description: "冬に買いたくなる、身体が温まるアイテムです",
                                               point: "一家に一台必須",
                                               reference: "https://cookpad.com/recipe/2798655",
                                               recommend_degrees: 5,
                                               picture: picture2 } }
      redirect_to item
      follow_redirect!
      expect(response).to render_template('items/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      # 編集
      get edit_item_path(item)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch item_path(item), params: { item: { name: "test",
                                               description: "冬に買いたくなる、身体が温まるアイテムです",
                                               point: "一家に一台必須",
                                               reference: "https://cookpad.com/recipe/2798655",
                                               recommend_degrees: 5 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      # 編集
      login_for_request(other_user)
      get edit_item_path(item)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      # 更新
      patch item_path(item), params: { item: { name: "test",
                                               description: "冬に買いたくなる、身体が温まるアイテムです",
                                               point: "一家に一台必須",
                                               reference: "https://cookpad.com/recipe/2798655",
                                               recommend_degrees: 5 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end