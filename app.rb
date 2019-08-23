require 'sinatra'

require "net/http"
require "uri"
require "json"
require "sqlite3"
 
class PhotoGallery < Sinatra::Base
    get '/' do
    erb :'index'
    end

    get '/photo' do
    fetch(1)
    erb :'photo'
    end
 
end

def fetch(image)
    @db = SQLite3::Database.new("./database.db")
    @db.execute("CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY , longUrl CHAR , likes INTEGER , user_id INT);")
    terms = "music"
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{terms}&image_type=photo")
    response = Net::HTTP.get_response(request)
    resp = JSON.parse(response.body)
    @db.execute("INSERT INTO photos(longUrl, likes, user_id) VALUES (?,?,?)",resp['hits'][0]['largeImageURL'],resp['hits'][0]['likes'],resp['hits'][0]['user_id'])
end