When 'I create the following article:' do |table|
  field_values = table.transpose.hashes.first

  fill_in 'Title', with: field_values[:title]
  fill_in 'Body', with: field_values[:body]
  click_button 'Create Article'
end
