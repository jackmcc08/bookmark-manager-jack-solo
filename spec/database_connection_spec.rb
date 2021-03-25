require 'database_connection'

describe DatabaseConnection do
	it 'setup' do
		connection = DatabaseConnection.setup('bookmark_manager_test')
		expect(connection.db).to eq('bookmark_manager_test')
	end

	it 'query' do
		expect(subject).to respond_to(:query).with(1).argument
	end
end