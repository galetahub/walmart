require 'sinatra'
require 'walmart/graber'
require 'walmart/searcher'

module Walmart
  class Application < ::Sinatra::Application
    set :public_folder, lambda { Walmart.root_path.join('public').to_s }
    set :views, lambda { Walmart.root_path.join('views').to_s }

    # Middleware
    use Rack::CommonLogger
    use Rack::Reloader

    get '/' do
      erb :index
    end

    post '/products' do
      @reviews = Graber.new(params[:product][:id]).reviews
      erb :products
    end

    get '/search' do
      erb :search
    end

    post '/filters' do
      search = Searcher.new(params[:product][:name])

      if search.product_id
        @reviews = Graber.new(search.product_id).reviews
        erb :products
      else
        redirect "/"
      end
    end
  end
end
