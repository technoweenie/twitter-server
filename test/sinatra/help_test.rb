require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiHelpTest < TwitterServer::TestCase
  class HelpApp < Sinatra::Base
    helpers  Sinatra::TwitterServer::Helpers
    register Sinatra::TwitterServer::Help

    twitter_help { |params| "ok: #{params.inspect}"}
  end

  def app
    HelpApp
  end

  it "returns 'Ok' for :xml format" do
    get '/help/test.xml'
    assert_equal 'ok: {:format=>"xml"}', last_response.body
  end
end