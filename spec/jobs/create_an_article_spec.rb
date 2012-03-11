require 'spec_helper'

describe CreateAnArticle do
  include_examples 'resque job', CreateAnArticle

  let(:announcer) { FakeAnnouncer.new }

  it 'announces a successful article creation' do
    CreateAnArticle.perform(announcer, :title => 'title', :body => 'body')

    created_article = Article.last
    created_article.should be_present
    created_article.title.should == 'title'
    created_article.body.should == 'body'

    announcer.should have_announced(:article_id).payload(created_article.id)
  end

  it 'announces a failed article creation' do
    failed_article = Article.new
    failed_article.valid?
    expected_payload = ActiveRecordMarshaller.new(failed_article)

    CreateAnArticle.perform(announcer, {})

    created_article = Article.last
    created_article.should be_nil

    announcer.should have_announced(:invalid_article).
      payload(expected_payload)
  end
end
