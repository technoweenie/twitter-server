require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiBasicAuthTest < TwitterServer::TestCase
  class BasicAuthApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_basic_auth do |user, pass|
      {:user => user, :pass => pass}
    end

    twitter_account_verify_credentials { |params| {:id => 1, :screen_name => "#{params[:auth][:user]} => #{params[:auth][:pass]}"} }
  end

  def app
    BasicAuthApp
  end

  it "passes auth hash to requests" do
    get '/account/verify_credentials.xml', {},
      'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("user:monkey")}".strip
    assert_xml do |xml|
      xml.user do
        xml.id_ 1
        xml.screen_name "user => monkey"
      end
    end
  end
end