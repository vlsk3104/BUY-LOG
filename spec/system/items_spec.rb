require 'rails_helper'

RSpec.describe "Items", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:item) { create(:item, :picture, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, item: item) }

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
        attach_file "item[picture]", "#{Rails.root}/spec/fixtures/test_item.jpg"
        click_button "登録する"
        expect(page).to have_content "アイテムが登録されました！"
      end

      it "画像無しで登録すると、デフォルト画像が割り当てられること" do
        fill_in "アイテム名", with: "test"
        click_button "登録する"
        expect(page).to have_link(href: item_path(Item.first))
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
        attach_file "item[picture]", "#{Rails.root}/spec/fixtures/test_item2.jpg"
        click_button "更新する"
        expect(page).to have_content "アイテム情報が更新されました！"
        expect(item.reload.name).to eq "編集：test"
        expect(item.reload.description).to eq "冬に買いたくなる、身体が温まるアイテムです"
        expect(item.reload.point).to eq "一家に一台必須"
        expect(item.reload.reference).to eq "henshu-https://cookpad.com/recipe/2798655"
        expect(item.reload.recommend_degrees).to eq 1
        expect(item.reload.picture.url).to include "test_item2.jpg"
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
        expect(page).to have_link nil, href: item_path(item), class: 'item-picture'
      end
    end

    context "コメントの登録＆削除" do
      it "自分のアイテムに対するコメントの登録＆削除が正常に完了すること" do
        login_for_system(user)
        visit item_path(item)
        fill_in "comment_content", with: "買って大成功"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: '買って大成功'
        end
        expect(page).to have_content "コメントを追加しました！"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).not_to have_selector 'span', text: '買って大成功'
        expect(page).to have_content "コメントを削除しました"
      end

      it "別ユーザーのアイテムのコメントには削除リンクが無いこと" do
        login_for_system(other_user)
        visit item_path(item)
        within find("#comment-#{comment.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: comment.content
          expect(page).not_to have_link '削除', href: item_path(item)
        end
      end
    end
  end
end