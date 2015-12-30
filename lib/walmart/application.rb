require 'sinatra'
require 'walmart/graber'

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
      graber = Graber.new(params[:product][:id])
      @reviews = graber.reviews.filter(params[:product][:filter])

      erb :products
    end
  end
end
