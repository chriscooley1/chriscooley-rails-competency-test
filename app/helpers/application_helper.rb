module ApplicationHelper
  def page_title
    if content_for?(:title)
      "#{content_for(:title)} · Simple News"
    else
      "Simple News"
    end
  end

  def story_date(time)
    time.strftime("%B #{time.day}, %Y")
  end

  def article_excerpt(article, length: 180)
    article.content.to_s.squish.truncate(length)
  end
end
