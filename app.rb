require 'sinatra'
 
class PhotoGallery < Sinatra::Base
 
  get '/' do
    "Hello, World!"
  end

  get '/photos' do
    "You wish"
  end
 
end