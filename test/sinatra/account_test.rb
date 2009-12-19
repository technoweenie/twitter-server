require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiAccountTest < TwitterServer::TestCase
  class AccountApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_account_verify_credentials { |params| "ok: #{params.inspect}"}
  end

  def app
    AccountApp
  end

  it "returns 'Ok' for :xml format" do
    get '/account/verify_credentials.xml'
    assert_equal 'ok: {:format=>"xml"}', last_response.body
  end
end