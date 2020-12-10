require 'rails_helper'

RSpec.describe "Items", type: :system do
  let!(:user) { create(:user) }
  let!(:item) { create(:item, user: user) }

  describe "アイテム登録ページ" do
    before do
      login_for_system(user)
      visit new_item_path
    end

    context "ページレイアウト" do
      it "「アイテム登録」の文字列が存在すること" do
        expect(page).to have_content 'アイテム登録'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('アイテム登録')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'アイテム名'
        expect(page).to have_content '説明'
        expect(page).to have_content 'ポイント'
        expect(page).to have_content '参照用URL'
        expect(page).to have_content 'おすすめ度 [1~5]'
        expect(page).to have_content 'Buy memo'
      end
    end

     context "アイテム登録処理" do
      it "有効な情報でアイテム登録を行うとアイテム登録成功のフラッシュが表示されること" do
        fill_in "アイテム名", with: "test"
        fill_in "説明", with: "冬に買いたくなる、身体が温まるアイテムです"
        fill_in "ポイント", with: "一家に一台必須"
        fill_in "参照用URL", with: "https://cookpad.com/recipe/2798655"
        fill_in "おすすめ度", with: 5
        click_button "登録する"
        expect(page).to have_content "アイテムが登録されました！"
      end

      it "無効な情報でアイテム登録を行うとアイテム登録失敗のフラッシュが表示されること" do
        fill_in "アイテム名", with: ""
        fill_in "説明", with: "冬に買いたくなる、身体が温まるアイテムです"
        fill_in "ポイント", with: "一家に一台必須"
        fill_in "参照用URL", with: "https://cookpad.com/recipe/2798655"
        fill_in "おすすめ度", with: 5
        click_button "登録する"
        expect(page).to have_content "アイテム名を入力してください"
      end
    end
  end

  describe "アイテム編集ページ" do
    before do
      login_for_system(user)
      visit item_path(item)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('アイテム情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'アイテム名'
        expect(page).to have_content '説明'
        expect(page).to have_content 'ポイント'
        expect(page).to have_content '参照用URL'
        expect(page).to have_content 'おすすめ度 [1~5]'
      end
    end

    context "アイテムの更新処理" do
      it "有効な更新" do
        fill_in "アイテム名", with: "編集：test"
        fill_in "説明", with: "冬に買いたくなる、身体が温まるアイテムです"
        fill_in "ポイント", with: "一家に一台必須"
        fill_in "参照用URL", with: "henshu-https://cookpad.com/recipe/2798655"
        fill_in "おすすめ度", with: 1
        click_button "更新する"
        expect(page).to have_content "アイテム情報が更新されました！"
        expect(item.reload.name).to eq "編集：test"
        expect(item.reload.description).to eq "冬に買いたくなる、身体が温まるアイテムです"
        expect(item.reload.point).to eq "一家に一台必須"
        expect(item.reload.reference).to eq "henshu-https://cookpad.com/recipe/2798655"
        expect(item.reload.recommend_degrees).to eq 1
      end

      it "無効な更新" do
        fill_in "アイテム名", with: ""
        click_button "更新する"
        expect(page).to have_content 'アイテム名を入力してください'
        expect(item.reload.name).not_to eq ""
      end
    end

    context "アイテムの削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'アイテムが削除されました'
      end
    end
  end

  describe "アイテム詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit item_path(item)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{item.name}")
      end

      it "アイテム情報が表示されること" do
        expect(page).to have_content item.name
        expect(page).to have_content item.description
        expect(page).to have_content item.point
        expect(page).to have_content item.reference
        expect(page).to have_content item.recommend_degrees
      end
    end

    context "アイテムの削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit item_path(item)
        within find('.change-item') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'アイテムが削除されました'
      end
    end
  end
end