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
        @id_set = params[:id]
        erb :'photo'
    end 

    not_found do
        erb :'404'
      end
 
end

def fetch(type = "music")
    @db = SQLite3::Database.new("./database.db")
    @db.execute("DROP TABLE photos") #Deletes the old data
    @db.execute("CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY , longUrl CHAR , user_id INT , previewURL CHAR);")
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{type}&image_type=photo&orientation=horizontal")
    response = Net::HTTP.get_response(request)
    resp = JSON.parse(response.body)

    i = 0
    while i < 9  do #Saves the first 9 photos in the database
        res = resp['hits'][i] #Breaks down the request array
        @db.execute("INSERT INTO photos(longUrl, user_id, previewURL) VALUES (?,?,?)",res['largeImageURL'],res['user_id'], res['previewURL'])
        i += 1
    end
end
