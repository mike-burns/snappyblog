Then /^I see the article titled "([^"]*)"$/ do |article_title|
  article = Article.find_by_title!(article_title)

  page.should have_content(article.title)
  page.should have_content(article.body)
end

Then /^the article titled "([^"]+)" is announced$/ do |article_title|
  @monitor_announcer.should have_announcement(:article_id)
  announcement = @monitor_announcer.recently_keyed_on(:article_id)
  (_connection_id, (_key, article_id)) = announcement
  article = Article.find_by_id!(article_id)
  article.title.should == article_title
end
