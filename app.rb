require 'sinatra/base'
require './lib/bookmarks'
require 'sinatra/reloader'
require 'sinatra/flash'
Bookmarks.setup

class BookmarksManager < Sinatra::Base
  enable :sessions, :method_override

  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader # this is from the Sinatra contrib gem
  end

  get '/' do
    flash[:bookmarks] = "Welcome to the Bookmarks Page"
    erb :index
  end

  get '/bookmarks' do

    @bookmarks = Bookmarks.all
    erb :bookmarks
  end

  get '/bookmarks/new' do
    erb :bookmarks_new
  end

  post '/bookmarks' do
    if Bookmarks.not_a_url?(params[:url])
      flash[:not_url] = "You did not enter a correct URL, please ensure it starts with http:// or https:// and ends with .com or other suitable ending."
      redirect back
    end
    Bookmarks.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    Bookmarks.delete(id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/update' do
    @bookmark = Bookmarks.find(params[:id])
    erb :update_bookmark
  end

  patch '/bookmarks/:id' do
    if Bookmarks.not_a_url?(params[:url])
      flash[:not_url] = "You did not enter a correct URL, please ensure it starts with http:// or https:// and ends with .com or other suitable ending."
      redirect back
    end
    Bookmarks.update(params[:id], params[:title], params[:url])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/comment' do
    @bookmark = Bookmarks.find(params[:id])
    erb :enter_comment
  end

  post '/bookmarks/:id' do
    Bookmarks.comment(params[:id], params[:comment])
    redirect '/bookmarks'
  end

  run! if app_file == $0
end
