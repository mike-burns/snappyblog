require 'announcer'

class CreateAnArticle
  @queue = :article

  def self.perform(announcer, web_params)
    article = Article.new(web_params)

    if article.save
      announcer.key(:article_id).payload(article.id).announce
    else
      announcer.key(:invalid_article).payload(article).announce
    end
  end
end
