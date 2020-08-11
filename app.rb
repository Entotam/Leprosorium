require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'pony'
require 'sqlite3'

set :database, {adapter: 'sqlite3', database: 'leprosorium.db'}

class Post < ActiveRecord::Base
	validates :username, presence: true
	validates :content, presence: true, length: { minimum: 2 }
end

class Comment < ActiveRecord::Base

end

before do
	@posts = Post.order "created_at DESC"
end

get '/' do
	erb :index			
end

get '/new' do
	@p = Post.new
	erb :new
end

post '/new' do
	@p = Post.new params[:post]
	if @p.save
		redirect to '/'
	else
		@error = @p.errors.full_messages.first
	end

	erb :new
end

get '/details/:id' do
	@p = Post.find(params[:id])
	erb :details
end

post '/details/:id' do
	erb :details
end

# get '/details/:post_id' do
# 	post_id = params[:post_id]

# 	result = @db.execute 'select * from Posts where id = ?', [post_id]
# 	@row = result[0]

# 	@comments = @db.execute 'select * from Comments where post_id = ?', [post_id]

# 	erb :details
# end

# post '/details/:post_id' do
# 	post_id = params[:post_id]
# 	content = params[:content]

# 	if content.length > 0
# 		@db.execute 'insert into Comments (created_date, content, post_id) values (datetime(), ?, ?)', [content, post_id]
# 	end

# 	redirect to ('/details/' + post_id)
# end