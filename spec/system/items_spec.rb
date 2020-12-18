require 'rails_helper'

RSpec.describe "Items", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:item) { create(:item, :picture, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, item: item) }
  let!(:log) { create(:log, item: item) }

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
        expect(page).to have_content 'バイメモ'
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

    context "ログ登録＆削除" do
      context "アイテム詳細ページから" do
        it "自分のアイテムに対するログ登録＆削除が正常に完了すること" do
          login_for_system(user)
          visit item_path(item)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "ログ追加"
          within find("#log-#{Log.first.id}") do
            expect(page).to have_selector 'span', text: "#{item.logs.count}回目"
            expect(page).to have_selector 'span',
                                          text: %Q(#{Log.last.created_at.strftime("%Y/%m/%d(%a)")})
            expect(page).to have_selector 'span', text: 'ログ投稿テスト'
          end
          expect(page).to have_content "バイログを追加しました！"
          click_link "削除", href: log_path(Log.first)
          expect(page).not_to have_selector 'span', text: 'ログ投稿テスト'
          expect(page).to have_content "バイログを削除しました"
        end

        it "別ユーザーのアイテムログにはログ登録フォームが無いこと" do
          login_for_system(other_user)
          visit item_path(item)
          expect(page).not_to have_button "買う"
        end
      end

      context "トップページから" do
        it "自分のアイテムに対するログ登録が正常に完了すること" do
          login_for_system(user)
          visit root_path
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq 'ログ投稿テスト'
          expect(page).to have_content "バイログを追加しました！"
        end

        it "別ユーザーのアイテムにはログ登録フォームがないこと" do
          create(:item, user: other_user)
          login_for_system(user)
          user.follow(other_user)
          visit root_path
          within find("#item-#{Item.first.id}") do
            expect(page).not_to have_button "買う"
          end
        end
      end

      context "プロフィールページから" do
        it "自分のアイテムに対するログ登録が正常に完了すること" do
          login_for_system(user)
          visit user_path(user)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq 'ログ投稿テスト'
          expect(page).to have_content "バイログを追加しました！"
        end
      end

      context "リスト一覧ページから" do
        it "自分のアイテムに対するログ登録が正常に完了し、リストからアイテムが削除されること" do
          login_for_system(user)
          user.list(item)
          visit lists_path
          expect(page).to have_content item.name
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq 'ログ投稿テスト'
          expect(page).to have_content "バイログを追加しました！"
          expect(List.count).to eq 0
        end
      end
    end
  end

  context "検索機能" do
    context "ログインしている場合" do
      before do
        login_for_system(user)
        visit root_path
      end

      it "ログイン後の各ページに検索窓が表示されていること" do
        expect(page).to have_css 'form#item_search'
        visit about_path
        expect(page).to have_css 'form#item_search'
        visit use_of_terms_path
        expect(page).to have_css 'form#item_search'
        visit users_path
        expect(page).to have_css 'form#item_search'
        visit user_path(user)
        expect(page).to have_css 'form#item_search'
        visit edit_user_path(user)
        expect(page).to have_css 'form#item_search'
        visit following_user_path(user)
        expect(page).to have_css 'form#item_search'
        visit followers_user_path(user)
        expect(page).to have_css 'form#item_search'
        visit items_path
        expect(page).to have_css 'form#item_search'
        visit item_path(item)
        expect(page).to have_css 'form#item_search'
        visit new_item_path
        expect(page).to have_css 'form#item_search'
        visit edit_item_path(item)
        expect(page).to have_css 'form#item_search'
      end

      it "フィードの中から検索ワードに該当する結果が表示されること" do
        create(:item, name: 'かに玉', user: user)
        create(:item, name: 'かに鍋', user: other_user)
        create(:item, name: '野菜炒め', user: user)
        create(:item, name: '野菜カレー', user: other_user)

        # 誰もフォローしない場合
        fill_in 'q_name_cont', with: 'かに'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”かに”の検索結果：1件"
        within find('.items') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_name_cont', with: '野菜'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”野菜”の検索結果：1件"
        within find('.items') do
          expect(page).to have_css 'li', count: 1
        end

        # other_userをフォローする場合
        user.follow(other_user)
        fill_in 'q_name_cont', with: 'かに'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”かに”の検索結果：2件"
        within find('.items') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_name_cont', with: '野菜'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”野菜”の検索結果：2件"
        within find('.items') do
          expect(page).to have_css 'li', count: 2
        end
      end

      it "検索ワードを入れずに検索ボタンを押した場合、アイテム一覧が表示されること" do
        fill_in 'q_name_cont', with: ''
        click_button '検索'
        expect(page).to have_css 'h3', text: "アイテム一覧"
        within find('.items') do
          expect(page).to have_css 'li', count: Item.count
        end
      end
    end

    context "ログインしていない場合" do
      it "検索窓が表示されないこと" do
        visit root_path
        expect(page).not_to have_css 'form#item_search'
      end
    end
  end
end
