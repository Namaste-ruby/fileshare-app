require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

# Base class for ShareFilesApp Web Application
class ShareFilesApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY'],
                             expire_after: 60 * 60 * 24 * 7
  use Rack::Flash

  configure :production do
    use Rack::SslEnforcer
  end

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  before do
    if session[:current_account]
      @current_account = SecureMessage.decrypt(session[:current_account])
    end
  end

  get '/' do
    slim :home
  end

  get '/api/wakeup' do
    if APIServerWakeUp.call
      status 200
    else
      status 404
    end
  end
end
