require 'sinatra'

require "net/http"
require "uri"
require "json"
 
class PhotoGallery < Sinatra::Base

    def initialize
        @db = SQLite3::Database.new("./database.db")
        @db.execute("CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY , longUrl CHAR , likes INTEGER , user_id INT);")
    end 
 
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
    resp = resp['hits']
    @db.execute("INSERT INTO photos(longUrl, likes, user_id) VALUES (?,?,?)",resp[0]['largeImageURL'],resp[0]['likes'],resp[0]['user_id'])
end