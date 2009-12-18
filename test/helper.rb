require 'rubygems'
require 'context'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rack/test'
require 'twitter_server'

module TwitterServer
  class TestCase < Test::Unit::TestCase
    include Rack::Test::Methods
  end
end
