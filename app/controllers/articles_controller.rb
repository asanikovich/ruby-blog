class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "alsan", password: "alsan", except: [:index, :show, :like]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)

    uploaded_io = params[:article][:image]
    name = Time.now.to_i.to_s + uploaded_io.original_filename
    File.open(Rails.root.join('public', 'images', name), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @article.img = name

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])

    uploaded_io = params[:article][:image]
    name = Time.now.to_i.to_s + uploaded_io.original_filename
    File.open(Rails.root.join('public', 'images', name), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @article.img = name

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  def like
    if session[:likes].nil?
      session[:likes] = []
    end
    @article = Article.find(params[:id])
    if session[:likes].include? params[:id]
      @article.likes -= 1
      session[:likes].delete(params[:id])
    else
      session[:likes] << params[:id]
      if @article.likes.nil?
        @article.likes = 1
      else
        @article.likes += 1
      end
    end




    @article.save
    redirect_to @article
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
