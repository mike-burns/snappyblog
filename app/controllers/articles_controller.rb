class ArticlesController < ApplicationController
  before_filter :set_connection_id

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    Resque.enqueue(CreateAnArticle,
                   session[:connection_id],
                   params[:article])
    redirect_to articles_path
  end

  def show
    @article = Article.find(params[:id])
  end

  private

  def set_connection_id
    session[:connection_id] ||= session[:session_id]
  end
end
