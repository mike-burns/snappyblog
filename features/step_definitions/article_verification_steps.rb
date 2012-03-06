Then /^I see that I can jump to an article$/ do
  wait_for_key(:article_id)
  page.should have_content('Jump to it')
end

Then /^the article titled "([^"]+)" is announced$/ do |article_title|
  @monitor_announcer.should have_announcement(:article_id)
  announcement = @monitor_announcer.recently_keyed_on(:article_id)
  (_connection_id, (_key, article_id)) = announcement
  article = Article.find_by_id!(article_id)
  article.title.should == article_title
end
