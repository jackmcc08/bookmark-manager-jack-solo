require 'bookmarks.rb'
require 'database_helpers'
require 'pg'

describe Bookmarks do
	describe '.all' do
		it 'returns all bookmarks' do
			connection = PG.connect(dbname: 'bookmark_manager_test')
			# Add the test data
			bookmark = Bookmarks.create(url: "http://www.makersacademy.com", title: "Makers Academy")
			Bookmarks.create(url: "http://www.destroyallsoftware.com", title: "Destroy All Software")
			Bookmarks.create(url: "http://www.google.com", title: "Google")

			bookmarks = Bookmarks.all
			expect(bookmarks.length).to eq 3
			expect(bookmarks.first).to be_a Bookmarks
			expect(bookmarks.first.id).to eq bookmark.id
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
			bookmark = Bookmarks.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')

			Bookmarks.delete(id: bookmark.id)

			expect(Bookmarks.all.length).to eq 0
		end
	end

	describe '.update' do
		it 'updates a bookmark entry based upon the user provided information' do
			bookmark = Bookmarks.create(url: 'http://www.testbookmark.com', title: 'Test Bookmark')
			persisted_data = persisted_data(id: bookmark.id)

			Bookmarks.update(persisted_data['id'], 'New Bookmark', 'http://www.testbookmark.com')

			bookmark = Bookmarks.all.first

			expect(bookmark).to be_a Bookmarks
			expect(bookmark.id).to eq persisted_data['id']
			expect(bookmark.title).to eq 'New Bookmark'
			expect(bookmark.url).to eq 'http://www.testbookmark.com'
		end
	end

	describe '.setup' do
		it 'connects to the database' do
			expect(Bookmarks.setup.db).to eq 'bookmark_manager_test'
		end
	end
end
