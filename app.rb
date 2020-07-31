require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
	return @db	
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" (
		"id"	INTEGER,
		"created_data"	REAL,
		"content"	TEXT,
		PRIMARY KEY("id" AUTOINCREMENT)
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/posts' do
	erb :posts
end

get '/new' do
	erb :new
end

post '/new' do
	content = params[:content]

	erb "We will post your post"
end
