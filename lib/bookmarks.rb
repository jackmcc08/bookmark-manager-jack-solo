require 'pg'

class Bookmarks
	attr_reader :id, :title, :url

	def initialize(id:, title:, url:)
		@id  = id
		@title = title
		@url = url
	end

	def self.all
		connection = database_connect

		result = connection.exec("SELECT * FROM bookmarks")

		result.map do |bookmark|
			Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
		end
	end

	def self.create(url:, title:)
		connection = database_connect

		result = connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
		Bookmarks.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
	end

	def self.delete(id:)
		connection = database_connect
		connection.exec("DELETE FROM bookmarks WHERE id = #{id}")
	end

	def self.update(id, title, url)
		connection = database_connect
		connection.exec("UPDATE bookmarks SET url = '#{url}', title = '#{title}' WHERE id = #{id}")
	end

	private

	def self.database_connect
		if ENV['ENVIRONMENT'] == 'test'
			PG.connect(dbname: 'bookmark_manager_test')
		else
			PG.connect(dbname: 'bookmark_manager')
		end
	end

end
