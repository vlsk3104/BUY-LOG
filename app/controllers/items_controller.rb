class ItemsController < ApplicationController
  before_action :logged_in_user

  def new
    @item = Item.new
  end
end
