require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiAccountTest < TwitterServer::TestCase
  class AccountApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_basic_auth do |user, pass|
      {:user => user, :pass => pass}
    end
    twitter_account_verify_credentials { {:id => 1} }
    twitter_users_show { |params| {:id => 1, :screen_name => params.inspect, :status => {:text => 'holla'}} }
  end

  def app
    AccountApp
  end

  describe "account/verify credentials" do
    it "returns user xml" do
      get '/account/verify_credentials.xml'
      assert_xml do |xml|
        xml.user do
          xml.id_ 1
        end
      end
    end
  end

  describe "users/show" do
    it "returns user xml from given id" do
      get "/users/show/123.xml"
      assert_xml do |xml|
        xml.user do
          xml.id_ 1
          xml.screen_name %({:id=>"123"})
          xml.status do
            xml.text_ "holla"
          end
        end
      end
    end

    it "returns user xml from given user_id" do
      get "/users/show.xml?user_id=456"
      assert_xml do |xml|
        xml.user do
          xml.id_ 1
          xml.screen_name %({:user_id=>"456"})
          xml.status do
            xml.text_ "holla"
          end
        end
      end
    end

    it "returns user xml from given screen_name" do
      get "/users/show.xml?screen_name=789"
      assert_xml do |xml|
        xml.user do
          xml.id_ 1
          xml.screen_name %({:screen_name=>"789"})
          xml.status do
            xml.text_ "holla"
          end
        end
      end
    end
  end
end