class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @item = Item.find(params[:item_id])
    @user = @item.user
    @comment = @item.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@item.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment = Comment.find(params[:id])
    @item = @comment.item
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    end
    redirect_to item_url(@item)
  end
end
