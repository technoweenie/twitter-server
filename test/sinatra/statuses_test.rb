require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiStatusesTest < TwitterServer::TestCase
  class StatusesApp < Sinatra::Base
    register Sinatra::TwitterServer

    twitter_statuses_friends_timeline { |params| "friend status (#{params.delete(:format)}): #{params.inspect}"}
    twitter_statuses_user_timeline    { |params| "user status (#{params.delete(:format)}): #{params.inspect}"}
  end

  def app
    StatusesApp
  end

  describe "user timeline" do
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

  describe "friends timeline" do
    [:since_id, :max_id, :count, :page].each do |key|
      it "takes #{key} param for :xml format" do
        get "/statuses/friends_timeline.xml?#{key}=1"
        assert_equal %(friend status (xml): {:#{key}=>"1"}), last_response.body
      end
    end
  end
end