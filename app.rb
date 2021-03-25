require 'sinatra/base'
require './lib/bookmarks'

class BookmarksManager < Sinatra::Base
  enable :sessions, :method_override

  get '/' do
    erb(:index)
  end

  get '/bookmarks' do
    @bookmarks = Bookmarks.all
    erb(:bookmarks)
  end

  get '/bookmarks/new' do
    erb(:bookmarks_new)
  end

  post '/bookmarks' do
    Bookmarks.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    Bookmarks.delete(id: params[:id])
    redirect '/bookmarks'
  end

  patch '/bookmarks/:id/update' do
    Bookmarks.update(id: params[:id])
    redirect '/bookmarks'
  end

  run! if app_file == $0
end
