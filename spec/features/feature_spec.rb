require './app.rb'
require 'pg'
require_relative 'web_helpers.rb'

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
    visit('/bookmarks')

    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Destroy All Software',  href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
  end
end

feature 'New bookmark' do
  scenario 'form exists' do
    create_test_bookmark
    expect(page).to have_link('Test Bookmark', href: 'http://testbookmark.com')
  end
end

feature 'Deleting bookmark' do
  scenario 'button exists' do
    visit '/bookmarks'
    first('.bookmark').click_button 'Delete'
    expect(current_path).to eq '/bookmarks'
    expect(page).not_to have_link('Makers Academy', href: 'http://www.makersacademy.com')
  end
end

feature 'Update bookmark' do
  scenario 'button exists' do
    visit '/bookmarks'
    first('.bookmark').click_button 'Update'
    expect(current_path).to eq "/bookmarks/1/update"
    fill_in 'title', with: 'New Bookmark'
    click_button('Update')
    expect(page).to have_link('New Bookmark', href: 'http://www.makersacademy.com')
  end
end

feature 'Validates bookmark' do
  scenario 'an invalid bookmark url is added - no http:// or https:// is added' do
    visit '/bookmarks/new'
    fill_in 'url', with: 'google.com'
    fill_in 'title', with: 'New Bookmark'
    click_button('Submit')
    expect(page).to have_content('You did not enter a correct URL')
  end
end

feature 'comment on a bookmark' do
  scenario 'a user can add a comment to a bookmark and see it displayed' do
    visit '/bookmarks'
    first('.bookmark').click_button 'Comment'
    fill_in 'comment', with: 'This is my first comment'
    click_button 'Submit'
    visit '/bookmarks'
    first('.bookmark').click_button 'Comment'
    fill_in 'comment', with: 'This is my Second comment'
    click_button 'Submit'
    # Bookmarks.all.each { |bookmark| puts bookmark.id, bookmark.title,  bookmark.comments }
    expect(page).to have_content 'This is my first comment'
    expect(page).to have_content 'This is my Second comment'
  end
end

feature 'tag a bookmark' do
  scenario 'a user can add a tag to a bookmark and see it displayed on the bookmarks page' do
    visit '/bookmarks'
    first('.bookmark').click_button 'Tag'
    fill_in 'tag', with: '#Makers'
    click_button 'Submit'
    expect(page).to have_content '#Makers'
  end
end

feature 'see all bookmarks related to a tag' do
  scenario 'a user can click on a tag and see all bookmarks related to it' do
  end
end
