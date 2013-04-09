require 'sinatra'
require 'gcm'
require 'data_mapper'

class User
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
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

# Register user
post '/' do
	User.create(:name => params[:uid], :registration_id => params[:regid])
	redirect '/'
end

# Unregister user

# Update user