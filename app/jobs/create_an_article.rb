require 'announcer'
require 'active_record_marshaller'

class CreateAnArticle
  @queue = :article

  def self.perform(announcer, web_params)
    article = Article.new(web_params)

    if article.save
      announcer.key(:article_id).payload(article.id).announce
    else
      json_marshaller = ActiveRecordMarshaller.new(article)
      announcer.key(:invalid_article).payload(json_marshaller).announce
    end
  end
end
