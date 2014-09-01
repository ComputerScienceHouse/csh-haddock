require 'sinatra'
require 'haddock'

Haddock::Password.diction = 'words.txt'

configure :production do
  require 'rack-ssl-enforcer'
  use Rack::SslEnforcer
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

set :views, settings.root

get '/' do
  len = params[:length].to_i
  @length = case
    when len <= 0 then 16
    when len <  8 then  8
    when len > 31 then 31
    else len
  end
  @passwords = []
  10.times{ @passwords << Haddock::Password.generate(@length) }
  erb :index
end
