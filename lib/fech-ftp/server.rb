require 'sinatra'
module Fech
  class Server < Sinatra::Base
    get '/' do
      "SERVER!"
    end

    get '/table/:table_name' do
      # '/candidate-contribution'
      # '/committee-summary'
      # '/committee-linked?page=1&limit=100'
      # retrieve table
    end
  end
end
