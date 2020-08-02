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
		"username" TEXT,
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
	username = params[:username]

	if content.length < 1
		@error = 'Type post text'
		erb :new
	end

	@db.execute 'insert into Posts (created_date, content, username) values (datetime(), ?, ?)', [content, username]

	redirect to '/'
end

get '/details/:post_id' do
	post_id = params[:post_id]

	result = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = result[0]

	@comments = @db.execute 'select * from Comments where post_id = ?', [post_id]

	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	@db.execute 'insert into Comments (created_date, content, post_id) values (datetime(), ?, ?)', [content, post_id]

	redirect to ('/details/' + post_id)
end