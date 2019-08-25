require 'sinatra'
require "net/http"
require "uri"
require "json"
require "sqlite3"
 
class PhotoGallery < Sinatra::Base

    get '/' do
        fetch()
        erb :'index'
    end

    get '/photo' do
        fetch()
        erb :'photo'
    end

    not_found do
        'This is nowhere to be found.'
      end
 
end

def fetch(type = "vinyl")
    @db = SQLite3::Database.new("./database.db")
    @db.execute("DROP TABLE photos") #Deletes the old data
    @db.execute("CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY , longUrl CHAR , likes INTEGER , user_id INT);")
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{type}&image_type=photo&orientation=horizontal")
    response = Net::HTTP.get_response(request)
    resp = JSON.parse(response.body)

    i = 0
    while i < 9  do #Saves the first 9 photos in the database
        res = resp['hits'][i] #Breaks down the request array
        @db.execute("INSERT INTO photos(longUrl, likes, user_id) VALUES (?,?,?)",res['largeImageURL'],res['likes'],res['user_id'])
        i += 1
    end
end

def photo_page 

end
