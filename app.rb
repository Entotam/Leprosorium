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
		"created_date"	REAL,
		"content"	TEXT,
		PRIMARY KEY("id" AUTOINCREMENT)
	)'

	@db.execute 'CREATE TABLE IF NOT EXISTS "Comments" (
		"id"	INTEGER,
		"created_date"	REAL,
		"content"	TEXT,
		"post_id" INTEGER,
		PRIMARY KEY("id" AUTOINCREMENT)
	)'	
end

get '/' do
	@result =@db.execute 'select * from Posts order by id desc'

	erb :index			
end

get '/posts' do
	erb :posts
end

get '/new' do
	erb :new
end

post '/new' do
	content = params[:content]

	if content.length < 1
		@error = 'Type post text'
		erb :new
	end

	@db.execute 'insert into Posts (created_date, content) values (datetime(), ?)', [content]

	redirect to '/'
end

get '/details/:post_id' do
	post_id = params[:post_id]

	result = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = result[0]

	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	erb "You send a comment: #{content} for post with id: #{post_id}"
end