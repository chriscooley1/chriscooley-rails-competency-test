class ArticlesController < ApplicationController
  # The list is public. Reading needs an account. Writing needs an editor.
  access "You do not have permission to change articles.",
    all: [ :index ],
    user: [ :show ],
    editor: [ :new, :create, :edit, :update, :destroy ]

  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  # Access already required an editor. This only checks who wrote the story.
  before_action :require_author, only: [ :edit, :update, :destroy ]

  def index
    @section = Section.named(params[:category]) if params[:category].present?
    @articles = Article.recent.includes(:user, :section)
    @articles = @articles.where(section: @section) if @section
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
      @article = Article.includes(:user, :section).find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :section_id, :new_section_name)
    end

    # A guest turned away from a story goes to signup. Access would send them to login.
    def authenticate_user!(...)
      return super unless action_name == "show"

      store_location_for(:user, request.fullpath)
      redirect_to new_user_registration_path, alert: "Create an account to read the full story."
    end

    def require_author
      return if current_user.id == @article.user_id

      redirect_to articles_path, alert: "You can only edit or delete stories you created."
    end
end
