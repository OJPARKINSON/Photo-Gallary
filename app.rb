require 'sinatra'

require "net/http"
require "uri"
require "json"
 
class PhotoGallery < Sinatra::Base
 
  get '/' do
    erb :'index'
  end

  get '/photos' do,
    fetch
    "You wish"
  end
 
end

def fetch
    terms = "flowers+summer"
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{terms}&image_type=photo")
    response = Net::HTTP.get_response(request)
    parsed = JSON.parse(response.body)
    puts parsed
end