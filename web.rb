require 'sinatra'
require 'gcm'
require 'data_mapper'
require 'json'

class User
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true, :unique => true
	property :registration_id, Text, :required => true
	property :created_at, DateTime
	property :updated_at, DateTime
end

configure do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/demo.db")
	DataMapper.finalize
	DataMapper.auto_migrate!

	User.create(:name => "David", :registration_id => "0219323")
end



# List all users
get '/users' do
	@users = User.all
	@title = "All users"
	erb :users
end

get '/users/:id' do
	@user = User.get params[:id]
	erb :user
end

get '/users.json/:id' do
	content_type :json
	u = User.get params[:id]
	unless u.nil?
		u.to_json
	else
		status 400
		{:status => 'error', :message => 'user not found'}.to_json
	end
end

# Register user
post '/users' do
	u = User.new
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.created_at = Time.now
	u.updated_at = Time.now
	u.save

	redirect '/users'
end

post '/users.json' do
	content_type :json

	u = User.new
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.created_at = Time.now
	u.updated_at = Time.now
	if u.save
		u.to_json
	else
		status 400
		{:status => 'error', :message => 'could not create user'}.to_json
	end
end

post '/users/:id' do
	u = User.get params[:id]
	gcm = GCM.new(api_key)
	message = {data: {subject: params[:subject], body: params[:body]}, collapse_key: "new_msg"}
	response = gcm.send_notification(u.registration_id, message)
end

# Unregister user
delete '/users/:id' do
	u = User.get params[:id]
	u.destroy
	redirect '/users'
end

# JSON
delete '/users.json/:id' do
	content_type :json
	u = User.get params[:id]
	if u.destroy
		{:status => 'success', :message => 'user deleted'}.to_json
	else
		status 400
		{:status => 'error', :message => 'user could not be deleted'}.to_json
	end
end

# Update user
put '/users/:id' do
	u = User.get params[:id]
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.updated_at = Time.now
	u.save
	redirect '/users'
end

put '/users/by_name/:uid/' do
	u = User.first(:name => params[:uid])
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.updated_at = Time.now
	u.save
	redirect '/users'
end

# JSON
put '/users.json/:id' do
	content_type :json
	u = User.get params[:id]
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.updated_at = Time.now
	if u.save
		u.to_json
	else
		{:status => 'error', :message => 'could not create user'}.to_json
	end
end