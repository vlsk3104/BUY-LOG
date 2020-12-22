class LogsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :create

  def create
    @item = Item.find(params[:item_id])
    @log = @item.logs.build(content: params[:log][:content])
    @log.save
    flash[:success] = "バイログを追加しました！"
    # リスト一覧ページからバイログが作成された場合、そのアイテムをリストから削除
    List.find(params[:list_id]).destroy unless params[:list_id].nil?
    redirect_to item_path(@item)
  end

  def destroy
    @log = Log.find(params[:id])
    @item = @log.item
    if current_user == @item.user
      @log.destroy
      flash[:success] = "バイログを削除しました"
    end
    redirect_to item_url(@item)
  end

  private

    def correct_user
      # 現在のユーザーが対象のアイテムを保有しているかどうか確認
      item = current_user.items.find_by(id: params[:item_id])
      redirect_to root_url if item.nil?
    end
end
