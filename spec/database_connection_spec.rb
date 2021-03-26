require 'database_connection'

describe DatabaseConnection do
	 it 'setup' do
 		 connection = DatabaseConnection.setup('bookmark_manager_test')
 		 expect(connection.db).to eq('bookmark_manager_test')
 	end

	 it 'query' do
 		 expect(DatabaseConnection).to respond_to(:query).with(1).argument
 		 connection = DatabaseConnection.setup('bookmark_manager_test')
 		 sql = "INSERT INTO bookmarks (url, title) VALUES('https://www.github.com', 'github') RETURNING title;"
 		 expect(connection.query(sql)[0]['title']).to eq 'github'
 	end
end
