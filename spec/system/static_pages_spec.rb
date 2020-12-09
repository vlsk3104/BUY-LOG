require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "バイログの文字列が存在することを確認" do
        expect(page).to have_content 'バイログ'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "ヘルプページ" do
    before do
      visit about_path
    end

    it "バイログとは？の文字列が存在することを確認" do
      expect(page).to have_content 'バイログとは？'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('バイログとは？')
    end
  end

  describe "利用規約ページ" do
    before do
      visit use_of_terms_path
    end

    it "利用規約の文字列が存在することを確認" do
      expect(page).to have_content '利用規約'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('利用規約')
    end

    context "アイテムフィード", js: true do
        let!(:user) { create(:user) }
        let!(:item) { create(:item, user: user) }

        before do
          login_for_system(user)
        end

        it "アイテムのぺージネーションが表示されること" do
          login_for_system(user)
          create_list(:item, 6, user: user)
          visit root_path
          expect(page).to have_content "みんなのアイテム (#{user.items.count})"
          expect(page).to have_css "div.pagination"
          Item.take(5).each do |d|
            expect(page).to have_link d.name
          end
        end

        it "「新しいアイテムを記録する」リンクが表示されること" do
         visit root_path
         expect(page).to have_link "新しいアイテムを記録する", href: new_item_path
       end
     end
  end
end