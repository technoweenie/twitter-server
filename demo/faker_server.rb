$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sinatra'
require 'twitter_server'
require 'faker'
require 'active_support'

TwitterServer.xml_renderer = TwitterServer::Renderer::NokogiriRenderer

$user   = {:id => 1, :name => Faker::Name.name}
$friend = {:id => 2, :name => Faker::Name.name}
$statuses = {
  $user => [
    {:id => 1, :text => 'oh hai', :source => 'api'},
    {:id => 2, :text => 'lol wut', :source => 'api', :source_href => 'http://google.com'}
    ],
  $friend => [
    {:id => 3, :text => 'oh hai', :source => 'api'}
    ]
}

$users = [$user, $friend]
$users.each { |u| u[:screen_name] = u[:name].underscore }
$statuses.each do |user, statuses|
  statuses.each { |st| st[:user] = user }
end

$user_id_index     = $users.inject({}) { |memo, user| memo.update(user[:id] => user) }
$screen_name_index = $users.inject({}) { |memo, user| memo.update(user[:screen_name] => user) }

twitter_help

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

twitter_users_show do |params|
  if user_id = (params[:id] || params[:user_id])
    $user_id_index[user_id]
  elsif params[:screen_name]
    $screen_name_index[params[:screen_name]]
  end
end

twitter_account_verify_credentials do |params|
  $user.merge(:status => $statuses[$user].first)
end