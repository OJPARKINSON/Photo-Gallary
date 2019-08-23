require 'sinatra'

require "net/http"
require "uri"
require "json"
 
class PhotoGallery < Sinatra::Base
 
  get '/' do
    erb :'index'
  end

  get '/photo' do
    erb :'photo'
  end
 
end

def fetch(image)
    terms = "music"
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{terms}&image_type=photo")
    response = Net::HTTP.get_response(request)
    resp = JSON.parse(response.body)
    return resp['hits'][image]['largeImageURL']
end