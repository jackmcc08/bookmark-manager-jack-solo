# PG - Understanding the results of PG methods and classes

If like me you were confused by what the PG gem and its classes were producing, the below may help - I want to check my understanding with Leo as well.

When executing a SQL command on a database via the PG gem, my understanding is that you get returned an instance of the PG::Result class. You can verify this in testing with the following test: `expect(Bookmarks.comment('1', "This is also a comment")).to be_instance_of(PG::Result)`

This confused me because it felt very difficult to access the results of the information provided by the PG::Result - was it a hash, array or somthing else....(I believe it is made up of something called tuples.)

So I was looking into the resources and the documentation to try and understand it a bit better, and I found the pages for PG::Result and PG::Tuple and this helped me be able to interrogate and get information from the returns much easier.

So below are a list of methods and returns that I got to show how you can access the information.

note the initial code up until `Bookmarks.setup` is just Ruby class code to show how I was accessing the database.

Relevant Websites:
- https://deveiate.org/code/pg/PG/Result.html#method-i-cmd_tuples
- https://deveiate.org/code/pg/PG/Tuple.html


```Ruby
puts "Setup code - you should be able to apply to your own tests - may require some adjustment"

require 'pg'
require_relative 'database_connection'
require 'uri'

class Bookmarks
  def self.setup
 	 @@database = PG.connect(dbname: 'bookmark_manager_test')
  end

  def self.bookmarks
    @@database.exec("SELECT * FROM bookmarks")
  end

  def self.comments
    @@database.exec("SELECT * FROM comments")
  end
end
Bookmarks.setup


puts "Applying PG::Result methods to the output of an executed SQL query"
puts ""
# These commands below are methods from PG::Result
# https://deveiate.org/code/pg/PG/Result.html#method-i-cmd_tuples
p Bookmarks.bookmarks # #<PG::Result:0x00007f9b8391be98 status=PGRES_TUPLES_OK ntuples=2 nfields=3 cmd_tuples=2>
p Bookmarks.bookmarks[0] # {"id"=>"5", "title"=>"Jack McCarthy", "url"=>"https://jackmcc08.github.io"}
p Bookmarks.bookmarks[1] # {"id"=>"11", "title"=>"Alan Partridge", "url"=>"www.partridgegetslucky.com"}
p Bookmarks.bookmarks.inspect # "#<PG::Result:0x00007f9b8391b6c8 status=PGRES_TUPLES_OK ntuples=2 nfields=3 cmd_tuples=2>"
p Bookmarks.bookmarks.cmd_tuples() # 2
p Bookmarks.bookmarks.nfields() # 3
p Bookmarks.bookmarks.type_map # #<PG::TypeMapAllStrings:0x00007f9b8388aa60>
puts ""
puts "Intentional spacing"
puts ""
p Bookmarks.comments # #<PG::Result:0x00007f9b8391b150 status=PGRES_TUPLES_OK ntuples=4 nfields=3 cmd_tuples=4>
p Bookmarks.comments.tuple(1) # #<PG::Tuple comment_id: "2", comment: "This is my first comment", bookmark_id: "5">
p Bookmarks.comments.tuple(1)['comment'] # "This is my first comment"
p Bookmarks.comments.values # [["1", "This is my first comment", "5"], ["2", "This is my first comment", "5"], ["3", "blah blah", "5"], ["4", "blah blah", "11"]]
p Bookmarks.comments.tuple_values(0) # ["1", "This is my first comment", "5"]
puts ""
puts "Intentional Spacing"
puts ""
puts "Applying PG::Tuple methods to the output of an executed SQL query (note you need to access the tuple of the output first - have done this through .each)"
puts ""
Bookmarks.comments.each do |comment|
	# These commands below are methods from PG::Tuple
	# https://deveiate.org/code/pg/PG/Tuple.html
	p comment # {"comment_id"=>"1", "comment"=>"This is my first comment", "bookmark_id"=>"5"}
	p comment.inspect # "{\"comment_id\"=>\"1\", \"comment\"=>\"This is my first comment\", \"bookmark_id\"=>\"5\"}"
	p comment['comment'] # "This is my first comment"
	p comment.keys # ["comment_id", "comment", "bookmark_id"]
	p comment.values # ["1", "This is my first comment", "5"]
	puts ""
end

```
