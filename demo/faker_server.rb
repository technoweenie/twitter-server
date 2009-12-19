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

twitter_account_verify_credentials do |params|
  %(<?xml version="1.0" encoding="UTF-8"?><user><id>1401881</id></user>)
end