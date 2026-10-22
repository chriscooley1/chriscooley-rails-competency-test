class ArticlesController < ApplicationController
  # Guests may browse. Only editors may publish.
  access "You do not have permission to change articles.",
    all: [ :index, :show ],
    editor: [ :new, :create, :edit, :update, :destroy ]

  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  # Signup, rather than the login page Petergate uses for a denied guest.
  before_action :redirect_guests_to_signup, only: :show
  # Petergate knows the role, not which editor wrote the story.
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

    def redirect_guests_to_signup
      return if user_signed_in?

      store_location_for(:user, article_path(@article))
      redirect_to new_user_registration_path, alert: "Create an account to read the full story."
    end

    def require_author
      return if @article.manageable_by?(current_user)

      redirect_to articles_path, alert: "You can only edit or delete stories you created."
    end
end
