class CommentsController < ApplicationController
  http_basic_authenticate_with name: "alsan", password: "alsan", only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  def like
    if session[:comments].nil?
      session[:comments] = []
    end
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if session[:comments].include? params[:id]
      @comment.likes -= 1
      session[:comments].delete(params[:id])
    else
      session[:comments] << params[:id]
      if @comment.likes.nil?
        @comment.likes = 1
      else
        @comment.likes += 1
      end
    end
    @comment.save
    redirect_to @article
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end