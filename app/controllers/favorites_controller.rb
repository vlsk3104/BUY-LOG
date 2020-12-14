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
