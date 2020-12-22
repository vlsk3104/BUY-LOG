class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites
  end

  def create
    @item = Item.find(params[:item_id])
    @user = @item.user
    current_user.favorite(@item)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
    # 自分以外のユーザーからお気に入り登録があったときのみ通知を作成
    if @user != current_user
      @user.notifications.create(item_id: @item.id, variety: 1,
                                 from_user_id: current_user.id) # お気に入り登録は通知種別1
      @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    current_user.favorites.find_by(item_id: @item.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
