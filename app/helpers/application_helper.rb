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

  def section_style(section)
    tones = [ "#b45309", "#1d4e89", "#1b5e38", "#5b35b5", "#9f1239", "#0f766e" ]
    "--section: #{tones[(section.id - 1) % tones.length]}"
  end
end
