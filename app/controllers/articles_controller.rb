class ArticlesController < ApplicationController
  def index
    @articles = Article.all_with_pending
  end

  def new
    @article = Article.new
  end

  def create
    eventually(CreateAnArticle, params[:article])
    redirect_to articles_path
  end

  def show
    @article = Article.find(params[:id])
  end
end
