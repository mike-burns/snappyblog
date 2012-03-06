require 'announcer'

class CreateAnArticle
  @queue = :article

  def self.perform(connection_id, web_params)
    article = Article.create(web_params)

    Announcer.announce!(connection_id, [:article_id, article.id])
  end
end
