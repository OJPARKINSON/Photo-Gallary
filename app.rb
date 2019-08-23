require 'sinatra'
 
class PhotoGallery < Sinatra::Base
 
  get '/' do
    erb :'index'
  end

  get '/photos' do
    "You wish"
  end
 
end