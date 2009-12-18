require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiHelpTest < TwitterServer::TestCase
  class HelpApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_help { |params| "ok: #{params.inspect}"}
  end

  def app
    HelpApp
  end

  it "returns 'Ok' for :xml format" do
    get '/help/test.xml'
    assert_equal 'ok: {:format=>"xml"}', last_response.body
  end

  it "returns 'Ok' for :json format" do
    get '/help/test.json'
    assert_equal 'ok: {:format=>"json"}', last_response.body
  end
end