require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiAccountTest < TwitterServer::TestCase
  class AccountApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_account_verify_credentials { |params| {:id => 1} }
  end

  def app
    AccountApp
  end

  it "returns user xml" do
    get '/account/verify_credentials.xml'
    assert_xml last_response.body do |xml|
      xml.user do
        xml.id_ 1
      end
    end
  end
end