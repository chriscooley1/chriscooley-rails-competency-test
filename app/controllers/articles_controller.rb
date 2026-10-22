class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :redirect_guests_to_signup, only: :show

  def index
    @category = params[:category].presence_in(Article::CATEGORIES)
    @articles = Article.recent.includes(:user)
    @articles = @articles.where(category: @category) if @category
  end

  def show
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: "Story published."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Story updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Story deleted."
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :category)
    end

    def redirect_guests_to_signup
      return if user_signed_in?

      store_location_for(:user, article_path(@article))
      redirect_to new_user_registration_path, alert: "Create an account to read the full story."
    end
end
