class HomeController < ApplicationController
  def index
    @articles_by_category = Article.homepage_groups
  end
end
