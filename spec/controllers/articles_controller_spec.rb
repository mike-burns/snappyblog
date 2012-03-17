require 'spec_helper'

describe ArticlesController do
  it 'assigns one article' do
    article = create(:article)
    get :show, :id => article.id
    assigns(:article).should == article
  end

  it 'eventually creates an article' do
    fake_enqueuer = FakeEnqueuer.new
    AppropriateQueue.enqueuer = fake_enqueuer
    article_params = { :title => 'the title', :body => 'the body' }

    post :create, :article => article_params

    response.should redirect_to(articles_url)
    fake_enqueuer.should have_enqueued(CreateAnArticle).
      with(article_params)
  end

  it 'assigns the new article form for a blank article' do
    get :new
    assigns(:article).attributes.should == Article.new.attributes
  end

  it 'assigns the new article form given a JSON-ified article' do
    expected_article = Article.new(:title => 'hello').tap do |article|
      article.errors.add(:body, "can't be blank")
    end
    json = ActiveRecordMarshaller.new(expected_article).to_json

    get :new, :json => json

    assigns(:article).attributes.should == expected_article.attributes
    assigns(:article).errors.to_hash.should == expected_article.errors.to_hash
  end

  it 'assigns the list of all articles, including pending'
end
