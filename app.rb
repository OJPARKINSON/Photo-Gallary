require 'sinatra'
require "net/http"
require "uri"
require "json"
require "sqlite3"
 
class PhotoGallery < Sinatra::Base

    get '/' do
        @type = params[:type]
        fetch(@type)
        erb :'index'
    end

    get '/photo' do
        @id_set = params[:id]
        @type = params[:type]
        fetch(@type)
        erb :'photo'
    end 

    get '/photographer' do
        fetch()
        erb :'photographer'
    end 

    not_found do
        erb :'404'
      end
 
end

def fetch(type = "music")
    @db = SQLite3::Database.new("./database.db")
    @db.execute("DROP TABLE photos") #Deletes the old data
    @db.execute("CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY , longUrl CHAR , user_id INT, user TEXT , previewURL CHAR);")
    request = URI("https://pixabay.com/api/?key=#{ENV['PIXABAY_API_KEY']}&q=#{type}&image_type=photo&orientation=horizontal")
    resp = JSON.parse(Net::HTTP.get_response(request).body)
    
    i = 0
    while i < resp['hits'].count()  do #Saves the first 9 photos in the database
        res = resp['hits'][i]
         #Breaks down the request array
        @db.execute("INSERT INTO photos(longUrl, user_id, user, previewURL) VALUES (?,?,?,?)",res['largeImageURL'],res['user_id'], res['user'], res['previewURL'])
        i += 1
    end
end