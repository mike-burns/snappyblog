require 'announcer'

class CreateAnArticle
  @queue = :article

  def self.perform(announcer, web_params)
    article = Article.create(web_params)

    announcer.key(:article_id).payload(article.id).announce
  end
end
