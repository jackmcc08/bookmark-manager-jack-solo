require 'bookmarks.rb'
require 'database_helpers'
require 'pg'

describe Bookmarks do
	describe '.all' do
 	 	it 'returns all bookmarks' do
  	 	bookmarks = Bookmarks.all
  		expect(bookmarks.length).to eq 3
  		expect(bookmarks.first).to be_a Bookmarks
  		expect(bookmarks.first.id).to eq '1'
  		expect(bookmarks.first.title).to eq 'Makers Academy'
  		expect(bookmarks.first.url).to eq 'http://www.makersacademy.com'
  	end
 	end

	describe '.create' do
 	 	it 'creates a new bookmark' do
  	 	bookmark = Bookmarks.create(url: 'http://www.testbookmark.com', title: 'Test Bookmark')
  		persisted_data = persisted_data(id: bookmark.id)

  		expect(bookmark).to be_a Bookmarks
  		expect(bookmark.id).to eq persisted_data['id']
  		expect(bookmark.title).to eq 'Test Bookmark'
  		expect(bookmark.url).to eq 'http://www.testbookmark.com'
  	end
 	end

	describe '.delete' do
 	 	it 'deletes the given bookmark' do
  	 	Bookmarks.delete(id: 1)
			expect(Bookmarks.all.length).to eq 2
  	end
 	end

	describe '.update' do
 	  it 'updates a bookmark entry based upon the user provided information' do
   		Bookmarks.update(1, 'New Bookmark', 'http://www.testbookmark.com')

  		bookmark = Bookmarks.all.last

  		expect(bookmark).to be_a Bookmarks
  		expect(bookmark.id).to eq '1'
  		expect(bookmark.title).to eq 'New Bookmark'
  		expect(bookmark.url).to eq 'http://www.testbookmark.com'
  	end
 	end

	describe '.setup' do
		it 'connects to the database' do
  		expect(Bookmarks.setup.db).to eq 'bookmark_manager_test'
		end
 	end

	describe '.find' do
		it 'finds the correct entry in the database' do
			bookmark = Bookmarks.find(1)
			expect(bookmark.id).to eq '1'
		end
	end

	describe '.not_a_url?' do
		it 'returns false if the URL entered is not a correct URL' do
			expect(Bookmarks.not_a_url?('www.cats.com')).to be true
			expect(Bookmarks.not_a_url?('http://www.cats.com')).to be false
		end
	end
end
