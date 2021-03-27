require 'bookmarks.rb'
require 'database_helpers'
require 'pg'

describe Bookmarks do
	describe '.all' do
 	 	it 'returns all bookmarks' do
			Bookmarks.comment('1', 'This is a comment')
			Bookmarks.tag('1', "#Makers")
  	 	bookmarks = Bookmarks.all
  		expect(bookmarks.length).to eq 3
  		expect(bookmarks.first).to be_a Bookmarks
  		expect(bookmarks.first.id).to eq '1'
  		expect(bookmarks.first.title).to eq 'Makers Academy'
  		expect(bookmarks.first.url).to eq 'http://www.makersacademy.com'
			expect(bookmarks.first.comments.first).to eq 'This is a comment'
			expect(bookmarks.first.tags.first).to eq '#Makers'
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

	describe '.comment' do
		it 'adds a comment to a bookmark' do
			expect(Bookmarks.comment('1', "This is also a comment")).to be_instance_of(PG::Result)
			expect(Bookmarks.comment('1', "This is a comment")[0]['comment']).to eq "This is a comment"
		end
	end

	describe '.tag' do
		it 'adds a tag to a bookmark' do
			expect(Bookmarks.tag('1', "#Makers")).to be_instance_of(PG::Result)
			expect(Bookmarks.tag('1', "#Makers").first['bookmark_tagid']).to eq "2"
		end
	end
end
