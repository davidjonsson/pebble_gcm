require 'sinatra'
require 'gcm'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'])

class User
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
	property :created_at, DateTime
	property :update_at, DateTime
end

DataMapper.finalize.auto_upgrade!

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