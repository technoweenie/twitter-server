require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiStatusesTest < TwitterServer::TestCase
  class StatusesApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_user_statuses { |params| "user status (#{params.delete(:format)}): #{params.inspect}"}
  end

  def app
    StatusesApp
  end

  it "returns 'Ok' for :xml format" do
    get '/statuses/user_timeline.xml'
    assert_equal 'user status (xml): {}', last_response.body
  end

  describe "requests without :id" do
    [:user_id, :screen_name, :since_id, :max_id, :count, :page].each do |key|
      it "takes #{key} param for :xml format" do
        get "/statuses/user_timeline.xml?#{key}=1"
        assert_equal %(user status (xml): {:#{key}=>"1"}), last_response.body
      end
    end
  end

  describe "requests with :id" do
    [:user_id, :screen_name, :since_id, :max_id, :count, :page].each do |key|
      it "takes #{key} param for :xml format" do
        get "/statuses/user_timeline/bob.xml?#{key}=1"
        assert_match /^user status \(xml\)\: \{/, last_response.body
        assert_match /\:#{key}\=\>\"1\"/,    last_response.body
        assert_match /\:id\=\>\"bob\"/,      last_response.body
      end
    end
  end
end