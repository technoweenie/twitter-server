require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

class ApiStatusesTest < TwitterServer::TestCase
  class StatusesApp < Sinatra::Base
    register Sinatra::TwitterServer

    
    resp = lambda do |params|
      user = {:id => 1, :screen_name => 'user'}
      statuses = []
      [:id, :user_id, :screen_name, :since_id, :max_id, :count, :page].each do |key|
        statuses << {:text => "#{key}=#{params[key]}", :user => user}
      end
      statuses
    end
    twitter_statuses_home_timeline    &resp
    twitter_statuses_friends_timeline &resp
    twitter_statuses_user_timeline    &resp
  end

  def app
    StatusesApp
  end

  describe "user timeline" do
    it "requests without :id return statuses xml" do
      get "/statuses/user_timeline.xml?user_id=1&screen_name=2&since_id=3&max_id=4&count=5&page=6"
      assert_xml do |xml|
        xml.statuses do
          xml.status do
            xml.text_ "id="
            xml.user do
              xml.id_ 1
              xml.screen_name 'user'
            end
          end
          [:user_id, :screen_name, :since_id, :max_id, :count, :page].each_with_index do |key, idx|
            xml.status do
              xml.text_ "#{key}=#{idx+1}"
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
        end
      end
    end

    it "requests with :id return statuses xml" do
      get "/statuses/user_timeline/bob.xml?user_id=1&screen_name=2&since_id=3&max_id=4&count=5&page=6"
      assert_xml do |xml|
        xml.statuses do
          xml.status do
            xml.text_ "id=bob"
            xml.user do
              xml.id_ 1
              xml.screen_name 'user'
            end
          end
          [:user_id, :screen_name, :since_id, :max_id, :count, :page].each_with_index do |key, idx|
            xml.status do
              xml.text_ "#{key}=#{idx+1}"
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
        end
      end
    end
  end

  describe "home timeline" do
    it "returns statuses xml" do
      get "/statuses/home_timeline.xml?since_id=1&max_id=2&count=3&page=4"
      assert_xml do |xml|
        xml.statuses do
          [:id, :user_id, :screen_name].each do |key|
            xml.status do
              xml.text_ "#{key}="
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
          [:since_id, :max_id, :count, :page].each_with_index do |key, idx|
            xml.status do
              xml.text_ "#{key}=#{idx+1}"
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
        end
      end
    end
  end

  describe "friends timeline" do
    it "returns statuses xml" do
      get "/statuses/friends_timeline.xml?since_id=1&max_id=2&count=3&page=4"
      assert_xml do |xml|
        xml.statuses do
          [:id, :user_id, :screen_name].each do |key|
            xml.status do
              xml.text_ "#{key}="
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
          [:since_id, :max_id, :count, :page].each_with_index do |key, idx|
            xml.status do
              xml.text_ "#{key}=#{idx+1}"
              xml.user do
                xml.id_ 1
                xml.screen_name 'user'
              end
            end
          end
        end
      end
    end
  end
end