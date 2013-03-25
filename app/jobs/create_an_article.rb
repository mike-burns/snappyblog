require 'active_record_marshaller'

class CreateAnArticle
  @queue = :article

  def self.perform(announcer, web_params)
    article = Article.new(web_params)

    if article.save
      announcer.notify(article_id: article.id)
    else
      json_marshaller = ActiveRecordMarshaller.new(article)
      announcer.notify(invalid_article: json_marshaller)
    end
  end
end
