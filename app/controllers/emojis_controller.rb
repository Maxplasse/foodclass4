class EmojisController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @emoji = Emoji.new(emoji_params)
    @emoji.post = @post
    @emoji.user = current_user
    authorize @emoji

    @emoji.save

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.text { render partial: "shared/emojis", locals: { post: @post }, formats: [:html], layout: false }
    end
  end

  private

  def emoji_params
    params.require(:emoji).permit(:content)
  end
end
