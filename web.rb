require 'sinatra'
require 'gcm'
require 'data_mapper'

class User
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
	property :created_at, DateTime
	property :update_at, DateTime
end

configure do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
	DataMapper.finalize
	DataMapper.auto_migrate!

	User.create(:name => "David")
end


# List all users
get '/' do
	erb :users
end

# Register user
post '/' do
	erb :users
end

# Unregister user

# Update user