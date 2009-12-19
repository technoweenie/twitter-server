$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sinatra'
require 'twitter_server'
require 'faker'

TwitterServer.xml_renderer = TwitterServer::Renderer::NokogiriRenderer

$user   = {:id => 1, :screen_name => Faker::Name.name}
$friend = {:id => 2, :screen_name => Faker::Name.name}
$statuses = {
  $user => [
    {:id => 1, :text => 'oh hai', :source => 'api'},
    {:id => 2, :text => 'lol wut', :source => 'api', :source_href => 'http://google.com'}
    ],
  $friend => [
    {:id => 3, :text => 'oh hai', :source => 'api'}
    ]
}

$statuses.each do |user, statuses|
  statuses.each { |st| st[:user] = user }
end

twitter_help do |params|
  if params[:format] == 'xml'
    '<ok>true</ok>'
  else
    'ok'
  end
end

twitter_statuses_home_timeline do |params|
  $statuses.values.flatten
end

twitter_statuses_friends_timeline do |params|
  $statuses.values.flatten
end

twitter_statuses_user_timeline do |params|
  user     = params[:user_id] == '1' ? $user : $friend
  $statuses[user]
end

twitter_account_verify_credentials do |params|
  $user.merge(:status => $statuses[$user].first)
end