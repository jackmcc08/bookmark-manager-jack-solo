require 'pg'
require './lib/database_connection'
require 'uri'

class Bookmarks
	attr_reader :id, :title, :url

	def initialize(id:, title:, url:)
 	  @id = id
 	 	@title = title
 	 	@url = url
 	end

	def self.all
 	  result = @@database.query("SELECT * FROM bookmarks")

 	  result.map do |bookmark|
		 	Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
  	end
	end

	def self.create(url:, title:)
		result = @@database.query("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
		Bookmarks.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
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
		@@database.query("SELECT * FROM bookmarks WHERE id = '#{id}'").map { |bookmark| Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url']) }[0]
	end

	def self.not_a_url?(url)
		!url.match?(/(http:\/\/)|(https:\/\/)/i)
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
