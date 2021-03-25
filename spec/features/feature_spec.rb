require './app.rb'
require 'pg'

feature 'index page' do
  scenario 'index page exists' do
    visit '/'
    expect(page).to have_content("Welcome")
  end
end

feature 'bookmarks page' do
  scenario 'exists' do
    visit '/bookmarks'
    expect(page).to have_content("Bookmarks:")
  end
end

feature 'Viewing bookmarks' do
  scenario 'A user can see bookmarks' do
    Bookmarks.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    Bookmarks.create(url: 'http://www.destroyallsoftware.com', title: 'Destroy All Software')
    Bookmarks.create(url: 'http://www.google.com', title: 'Google')

    visit('/bookmarks')

    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Destroy All Software',  href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
  end
end

feature 'New bookmark' do
  scenario 'form exists' do
    visit '/bookmarks/new'
    fill_in 'url', with: 'http://testbookmark.com'
    fill_in 'title', with: 'Test Bookmark'
    click_button('Submit')
    expect(page).to have_link('Test Bookmark', href: 'http://testbookmark.com')
  end
end

feature 'Deleting bookmark' do
  scenario 'button exists' do
    visit '/bookmarks/new'
    fill_in 'url', with: 'http://testbookmark.com'
    fill_in 'title', with: 'Test Bookmark'
    click_button('Submit')
    visit('/bookmarks')
    expect(page).to have_link('Test Bookmark', href: 'http://testbookmark.com')

    first('.bookmark').click_button 'Delete'

    expect(current_path).to eq '/bookmarks'
    expect(page).not_to have_link('Test Bookmark', href: 'http://testbookmark.com')
  end
end

feature 'Update bookmark' do
  scenario 'button exists' do
    visit '/bookmarks/new'
    fill_in 'url', with: 'http://testbookmark.com'
    fill_in 'title', with: 'Test Bookmark'
    click_button('Submit')
    visit('/bookmarks')
    expect(page).to have_link('Test Bookmark', href: 'http://testbookmark.com')

    first('.bookmark').click_button 'Update'

    connection = PG.connect(dbname: 'bookmark_manager_test')
    result = connection.exec("SELECT id FROM bookmarks WHERE title='Test Bookmark';")
    id = result.first['id']
    expect(current_path).to eq "/bookmarks/#{id}/update"
  end
end

