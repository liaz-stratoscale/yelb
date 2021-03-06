#################################################################################
####                           Massimo Re Ferre'                             ####
####                             www.it20.info                               ####
####                    Yelb, a simple web application                       ####
################################################################################# 
  
#################################################################################
####   yelb-appserver.rb is the app (ruby based) component of the Yelb app   ####
####          Yelb connects to a backend database for persistency            ####
#################################################################################

require 'socket'
require 'sinatra'
require 'pg'

# the disabled protection is required when running in production behind an nginx reverse proxy
# without this option, the angular application will spit a `forbidden` error message
disable :protection

# the system variable RACK_ENV controls which environment you are enabling 
configure :production do
  set :port, 4567
  set :yelbdbhost => "yelb-db"
  set :yelbdbport => 5432
end
configure :test do
  set :port, 4567
  set :yelbdbhost => "yelb-db"
  set :yelbdbport => 5432
end
configure :development do
  set :port, 4567
  set :yelbdbhost => "localhost"
  set :yelbdbport => 5432
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

  # Needed for AngularJS
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

  halt HTTP_STATUS_OK
end

def restaurantsdbread(restaurant)
    con = PG.connect  :host => settings.yelbdbhost,
                      :port => settings.yelbdbport,
                      :dbname => 'yelbdatabase',
                      :user => 'yelbdbuser',
                      :password => 'yelbdbuser'
    con.prepare('statement1', 'SELECT count FROM restaurants WHERE name =  $1')
    res = con.exec_prepared('statement1', [ restaurant ])
    return res.getvalue(0,0)
end 

def restaurantsdbupdate(restaurant)
    con = PG.connect  :host => settings.yelbdbhost,
                      :port => settings.yelbdbport,
                      :dbname => 'yelbdatabase',
                      :user => 'yelbdbuser',
                      :password => 'yelbdbuser'
    con.prepare('statement1', 'UPDATE restaurants SET count = count +1 WHERE name = $1')
    res = con.exec_prepared('statement1', [ restaurant ])
end

get '/api/hostname' do

    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'

	content_type 'application/json'
    @hostname = Socket.gethostname
end #get /api/hostname

get '/api/getstats' do

    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'

	content_type 'application/json'
    @hostname = Socket.gethostname
    @stats = '{"hostname": "' + @hostname + '"' +"}"
end #get /api/getstats


get '/api/getvotes' do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
    
    content_type 'application/json'
    @outback = restaurantsdbread("outback")
    @ihop = restaurantsdbread("ihop")
    @bucadibeppo = restaurantsdbread("bucadibeppo")
    @chipotle = restaurantsdbread("chipotle")
    @votes = '[{"name": "gcp", "value": ' + @outback + '},' + '{"name": "azure", "value": ' + @bucadibeppo + '},' + '{"name": "symphony", "value": '  + @ihop + '}, ' + '{"name": "aws", "value": '  + @chipotle + '}]'
end #get /api/getvotes 

get '/api/ihop' do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
 
    restaurantsdbupdate("ihop")
    @ihop = restaurantsdbread("ihop")
end #get /api/ihop 

get '/api/chipotle' do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
 
    restaurantsdbupdate("chipotle")
    @chipotle = restaurantsdbread("chipotle")
end #get /api/chipotle 

get '/api/outback' do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
 
    restaurantsdbupdate("outback")
    @outback = restaurantsdbread("outback")
end #get /api/outback 

get '/api/bucadibeppo' do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Authorization,Accepts,Content-Type,X-CSRF-Token,X-Requested-With'
    headers 'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS'
 
    restaurantsdbupdate("bucadibeppo")
    @bucadibeppo = restaurantsdbread("bucadibeppo")
end #get /api/bucadibeppo 

