require 'web_socket'

class CreateAnArticle
  @queue = :article

  def self.perform(connection_id, web_params)
    article = Article.create(web_params)

    client = WebSocket.new('ws://localhost:8080/')
    client.send(%{["#{connection_id}", ["article_id", #{article.id}]]})
  end
end
