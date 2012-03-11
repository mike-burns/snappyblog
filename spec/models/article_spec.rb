require 'spec_helper'
require 'noop_job'

describe Article do
  it 'produces all with pending articles' do
    Resque.enqueue(NoopJob.new(:article))
    db_article = create(:article)

    all_articles = Article.all_with_pending

    all_articles.should have(2).items
    all_articles.should include(db_article)
    all_articles.detect(&:pending?).should be_present
  end

  it 'produces parsed JSON if available' do
    title = 'The Title'
    body = 'The Body'
    json = {
      'json_class' => 'ActiveRecordMarshaller',
      'data' => {
        'active_record_class' => 'Article',
        'errors' => {},
        'attributes' => { 'title' => title, 'body' => body }
      }
    }.to_json

    article = Article.new_from_json(json)

    article.title.should == title
    article.body.should == body
  end

  it 'produces a new article if no JSON is available' do
    article = Article.new_from_json(nil)
    article.attributes.should == Article.new.attributes
    article.errors.to_hash.should == Article.new.errors.to_hash
  end
end
