require 'nokogiri'
module TwitterServer
  module Renderer
    class NokogiriRenderer
      def initialize(root)
        @xml = Nokogiri::XML::Builder.new
        node(root) { yield self }
      end

      def node(key)
        r = self
        @xml.send key do
          yield r
        end
      end

      def to_s
        @xml.to_xml
      end

      # <id>1401881</id>
      # <name>Doug Williams</name>
      # <screen_name>dougw</screen_name>
      # <location>San Francisco, CA</location>
      # <description>Twitter API Support. Internet, greed, users, dougw and opportunities are my passions.</description>
      # <profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/59648642/avatar_normal.png</profile_image_url>
      # <url>http://www.igudo.com</url>
      # <protected>false</protected>
      # <followers_count>1031</followers_count>
      # <profile_background_color>9ae4e8</profile_background_color>
      # <profile_text_color>000000</profile_text_color>
      # <profile_link_color>0000ff</profile_link_color>
      # <profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
      # <profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
      # <friends_count>293</friends_count>
      # <created_at>Sun Mar 18 06:42:26 +0000 2007</created_at>
      # <favourites_count>0</favourites_count>
      # <utc_offset>-18000</utc_offset>
      # <time_zone>Eastern Time (US & Canada)</time_zone>
      # <profile_background_image_url>http://s3.amazonaws.com/twitter_production/profile_background_images/2752608/twitter_bg_grass.jpg</profile_background_image_url>
      # <profile_background_tile>false</profile_background_tile>
      # <statuses_count>3390</statuses_count>
      # <notifications>false</notifications>
      # <following>false</following>
      # <geo_enabled>true</geo_enabled> <!-- Not yet part of the current payload.  [COMING SOON] -->
      # <verified>true</verified>
      def user(user)
        [:id, :name, :screen_name].each do |key|
          @xml.send "#{key}_", user[key] if user.key?(key)
        end
        if user.key?(:status)
          node(:status) do
            status(user[:status])
          end
        end
      end

      # <created_at>Tue Apr 07 22:52:51 +0000 2009</created_at>
      # <id>1472669360</id>
      # <text>At least I can get your humor through tweets. RT @abdur: I don't mean this in a bad way, but genetically speaking your a cul-de-sac.</text>
      # <source>&lt;a href="http://www.tweetdeck.com/">TweetDeck&lt;/a></source>
      # <truncated>false</truncated>
      # <in_reply_to_status_id></in_reply_to_status_id>
      # <in_reply_to_user_id></in_reply_to_user_id>
      # <favorited>false</favorited>
      # <in_reply_to_screen_name></in_reply_to_screen_name>
      def status(status)
        [:id, :created_at, :text, :truncated, :in_reply_to_status_id, :in_reply_to_user_id, :favorited, :in_reply_to_screen_name].each do |key|
          @xml.send("#{key}_", status[key]) if status.key?(key)
        end
        if status.key?(:user)
          node :user do
            user(status[:user])
          end
        end
        if status.key?(:source)
          if status.key?(:source_href)
            node :source do
              @xml.a(status[:source], :href => status[:source_href])
            end
          else
            @xml.source status[:source]
          end
        end
      end
    end
  end
end