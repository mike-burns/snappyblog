When 'I navigate to the article form' do
  visit root_path
  click_link 'Create an article'
end

When 'I navigate to the article I just made' do
  click_link 'Jump to it'
end
