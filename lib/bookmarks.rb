require 'pg'
require_relative 'database_connection'
require 'uri'

class Bookmarks
	attr_reader :id, :title, :url, :comments, :tags

	def initialize(id:, title:, url:, comments:, tags:)
 	  @id = id
 	 	@title = title
 	 	@url = url
		@comments = comments
		@tags = tags
 	end

	def self.all
 	  result = @@database.query("SELECT * FROM bookmarks")

 	  result.map do |bookmark|
			comments = []
			@@database.query("SELECT * FROM comments WHERE bookmark_ID=#{bookmark['id']}").each { |comment| comments << comment['comment'] }
			tag_ids = []
			@@database.query("SELECT * FROM bookmark_tags WHERE bookmarkID=#{bookmark['id']}").each { |bookmark_tag| tag_ids << bookmark_tag['tagid'] }
			tags = []
			tag_ids.each{ |id| tags << @@database.query("SELECT tag FROM tags WHERE tagID='#{id}'").first['tag'] }
			# p comments
			# comments.each { |x| puts x} unless comments.nil?
		 	Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'], comments: comments, tags: tags)
  	end
	end

	# def self.bookmarks
	# 	@@database.query("SELECT * FROM bookmarks")
	# end
	#
	# def self.comments
	# 	@@database.query("SELECT * FROM comments")
	# end

	def self.create(url:, title:)
		result = @@database.query("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
		Bookmarks.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'], comments: [], tags: [])
	end

 	def self.delete(id:)
		@@database.query("DELETE FROM bookmarks WHERE id = #{id}")
	end

  def self.update(id, title, url)
	  @@database.query("UPDATE bookmarks SET url = '#{url}', title = '#{title}' WHERE id = #{id}")
  end

  def self.setup
 	 @@database = database_connect
  end

	def self.find(id)
		@@database.query("SELECT * FROM bookmarks WHERE id = '#{id}'").map { |bookmark| Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'], comments: [], tags: []) }[0]
	end

	def self.not_a_url?(url)
		!url.match?(/(http:\/\/)|(https:\/\/)/i)
	end

	def self.comment(id, comment)
		@@database.query("INSERT INTO comments (comment, bookmark_ID) VALUES('#{comment}', '#{id}') RETURNING comment_id, comment, bookmark_ID")
	end

	def self.tag(id, tag)
		if @@database.query("SELECT * FROM tags WHERE tag='#{tag}'").first == nil
			@@database.query("INSERT INTO tags (tag) VALUES('#{tag}')")
		end
		tagID = @@database.query("SELECT * FROM tags WHERE tag='#{tag}'").first['tagid']
		@@database.query("INSERT INTO bookmark_tags (bookmarkID, tagID) VALUES('#{id}', '#{tagID}') RETURNING bookmark_tagID;")
	end

private
	def self.database_connect
		if ENV['ENVIRONMENT'] == 'test'
	 		DatabaseConnection.setup('bookmark_manager_test')
		else
  		DatabaseConnection.setup('bookmark_manager')
		end
	end
end

# Bookmarks.setup
# puts "Applying PG::Result methods to the output of an executed SQL query"
# puts ""
# # These commands below are methods from PG::Result
# # https://deveiate.org/code/pg/PG/Result.html#method-i-cmd_tuples
# p Bookmarks.bookmarks # #<PG::Result:0x00007f9b8391be98 status=PGRES_TUPLES_OK ntuples=2 nfields=3 cmd_tuples=2>
# p Bookmarks.bookmarks[0] # {"id"=>"5", "title"=>"Jack McCarthy", "url"=>"https://jackmcc08.github.io"}
# p Bookmarks.bookmarks[1] # {"id"=>"11", "title"=>"Alan Partridge", "url"=>"www.partridgegetslucky.com"}
# p Bookmarks.bookmarks.inspect # "#<PG::Result:0x00007f9b8391b6c8 status=PGRES_TUPLES_OK ntuples=2 nfields=3 cmd_tuples=2>"
# p Bookmarks.bookmarks.cmd_tuples() # 2
# p Bookmarks.bookmarks.nfields() # 3
# p Bookmarks.bookmarks.type_map # #<PG::TypeMapAllStrings:0x00007f9b8388aa60>
# puts ""
# puts "Intentional spacing"
# puts ""
# p Bookmarks.comments # #<PG::Result:0x00007f9b8391b150 status=PGRES_TUPLES_OK ntuples=4 nfields=3 cmd_tuples=4>
# p Bookmarks.comments.tuple(1) # #<PG::Tuple comment_id: "2", comment: "This is my first comment", bookmark_id: "5">
# p Bookmarks.comments.tuple(1)['comment'] # "This is my first comment"
# p Bookmarks.comments.values # [["1", "This is my first comment", "5"], ["2", "This is my first comment", "5"], ["3", "blah blah", "5"], ["4", "blah blah", "11"]]
# p Bookmarks.comments.tuple_values(0) # ["1", "This is my first comment", "5"]
# puts ""
# puts "Intentional Spacing"
# puts ""
# puts "Applying PG::Tuple methods to the output of an executed SQL query (note you need to access the tuple of the output first - have done this through .each)"
# puts ""
# Bookmarks.comments.each do |comment|
# 	# These commands below are methods from PG::Tuple
# 	# https://deveiate.org/code/pg/PG/Tuple.html
# 	p comment # {"comment_id"=>"1", "comment"=>"This is my first comment", "bookmark_id"=>"5"}
# 	p comment.inspect # "{\"comment_id\"=>\"1\", \"comment\"=>\"This is my first comment\", \"bookmark_id\"=>\"5\"}"
# 	p comment['comment'] # "This is my first comment"
# 	p comment.keys # ["comment_id", "comment", "bookmark_id"]
# 	p comment.values # ["1", "This is my first comment", "5"]
# 	puts ""
# end
