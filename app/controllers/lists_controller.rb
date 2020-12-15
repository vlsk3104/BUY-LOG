class ListsController < ApplicationController
  before_action :logged_in_user
  def index
    @lists = current_user.lists
  end

  def create
    @item = Item.find(params[:item_id])
    @user = @item.user
    current_user.list(@item)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    list = List.find(params[:list_id])
    @item = list.item
    list.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
