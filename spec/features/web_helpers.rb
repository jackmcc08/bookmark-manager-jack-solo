def create_test_bookmark
  visit '/bookmarks/new'
  fill_in 'url', with: 'http://testbookmark.com'
  fill_in 'title', with: 'Test Bookmark'
  click_button('Submit')
end
