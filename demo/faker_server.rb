$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sinatra'
require 'twitter_server'

twitter_help do |params|
  if params[:format] == 'xml'
    '<ok>true</ok>'
  else
    'ok'
  end
end