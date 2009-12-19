require 'rubygems'
require 'context'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rack/test'
require 'twitter_server'

module TwitterServer
  class TestCase < Test::Unit::TestCase
    include Rack::Test::Methods

    def assert_xml(actual = nil)
      xml = Nokogiri::XML::Builder.new
      yield xml
      expected = xml.to_xml
      actual ||= last_response.body
      assert_equal expected, actual, "EXPECTED\n#{expected}\nACTUAL\n#{actual}"
    end
  end
end
