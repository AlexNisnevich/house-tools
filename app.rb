require 'sinatra'
require 'json'
require 'yaml'

require_relative 'rent/month.rb'

before do
  @data = YAML.load(open('data.yml'))
  @globals = @data['globals']
end

get '/' do
  erb :index
end

get '/rent' do
  @months = @data['months'].map {|name, params| Month.new(name, params, @globals) }
                           .reject {|month| month.hidden }
                           .reverse
  @all_tenants = @globals['tenants']

  erb :rent
end

post '/rent/calculate' do
  month = Month.new('', JSON.parse(params[:params]), @globals)
  'Rent by room: ' + month.rent.to_s
end

get '/move_in_move_out' do
  erb :move_in_move_out
end
