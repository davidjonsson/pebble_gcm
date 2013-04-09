require 'sinatra'
require 'gcm'
require 'data_mapper'

class User
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true, :unique => true
	property :registration_id, Text, :required => true
	property :created_at, DateTime
	property :update_at, DateTime
end

configure do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/demo.db")
	DataMapper.finalize
	DataMapper.auto_migrate!

	User.create(:name => "David", :registration_id => "0219323")
end


# List all users
get '/' do
	@users = User.all
	@title = "All users"
	erb :users
end

get '/:id' do
	@user = User.get params[:id]
	erb :user
end

# Register user
post '/' do
	User.create(:name => params[:uid], :registration_id => params[:regid])
	redirect '/'
end

# Unregister user
delete '/:id' do
	u = User.get params[:id]
	u.destroy
	redirect '/'
end

# Update user
put '/:id' do
	u = User.get params[:id]
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.save
	redirect '/'
end

put '/:uid/by_name' do
	u = User.first(:name => params[:uid])
	u.name = params[:uid]
	u.registration_id = params[:regid]
	u.save
	redirect '/'
end