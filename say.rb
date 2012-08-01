#!/usr/bin/env ruby

# Bonjour example
# https://github.com/suwanny/Ruby-Practics/tree/master/discovery

  
require "rubygems"
require "sinatra"
require "haml"
require "socket"
require "mactts"

def hostname
  Socket.gethostbyname(Socket.gethostname).first
end
   

## TODO
def peers
  [hostname]
end

def index
  haml :index, :locals => { :hostname => hostname, 
                            :peers => peers,
                            :voices => Mac::TTS.valid_voices }
end

get "/" do
  index
end

post "/say" do
  Mac::TTS.say params[:message], params[:voice].to_sym
  index
end

__END__
@@ layout
%html
  %head
    %title Say
    %style{:type => "text/css"}
      form > * { display: block; }
  %body
    =yield

@@ index
%h1= hostname
%form{:action => "/say", :method => "POST"}
  %textarea{:name => "message"}
  %select{:name => "voice"}
    - voices.each do |voice|
      %option{:value => voice}= voice
  %input{:type => "submit"}
%ul
  - peers.each do |peer|
    %li
      %a{:href => "http://#{peer}:4567/"}
        =peer
