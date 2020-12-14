class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @item = Item.find(params[:item_id])
    @user = @item.user
    @comment = @item.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@item.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
      # 自分以外のユーザーからコメントがあったときのみ通知を作成
      if @user != current_user
        @user.notifications.create(item_id: @item.id, variety: 2,
                                   from_user_id: current_user.id,
                                   content: @comment.content) # コメントは通知種別2
        @user.update_attribute(:notification, true)
      end
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
