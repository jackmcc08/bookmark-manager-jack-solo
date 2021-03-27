require 'pg'

p "Setting up test database bookmarks table with 3 entries..."

def setup_test_database
	 connection = PG.connect(dbname: 'bookmark_manager_test')
	 connection.exec("TRUNCATE bookmarks;")
end

def connect_to_test_database
	 PG.connect(dbname: 'bookmark_manager_test')
end

def clean_test_database(connection)
	 connection.exec("DROP TABLE IF EXISTS bookmarks CASCADE")
	 connection.exec("DROP TABLE IF EXISTS comments")
end

def create_bookmarks_table_in_test(connection)
	connection.exec("CREATE TABLE bookmarks(id SERIAL PRIMARY KEY, url VARCHAR(60), title VARCHAR(60));")
	connection.exec("CREATE TABLE comments(comment_ID SERIAL PRIMARY KEY, comment VARCHAR(240), bookmark_ID integer REFERENCES bookmarks);")
end

def populate_bookmarks_table(connection)
	 connection.exec("INSERT INTO bookmarks (url, title) VALUES('http://www.makersacademy.com', 'Makers Academy'),('http://www.destroyallsoftware.com','Destroy All Software'),('http://www.google.com','Google')")
end

def setup_test_database_2
	 connection = connect_to_test_database
	 clean_test_database(connection)
	 create_bookmarks_table_in_test(connection)
	 populate_bookmarks_table(connection)
end
