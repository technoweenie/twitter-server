require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiHelpTest < TwitterServer::TestCase
  class HelpApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_help
  end

  def app
    HelpApp
  end

  it "returns 'Ok' for :xml format" do
    get '/help/test.xml'
    assert_equal Sinatra::TwitterServer::HELP_XML_RESPONSE, last_response.body
  end

  it "returns 'Ok' for :json format" do
    get '/help/test.json'
    assert_equal Sinatra::TwitterServer::HELP_RESPONSE, last_response.body
  end
end