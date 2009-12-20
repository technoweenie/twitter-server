require 'sinatra/base'
require 'base64'

module TwitterServer
  class << self
    attr_writer :xml_renderer
  end

  # IDEA: have set renderers for JSON/XML/ATOM/RSS
  # Then Sinatra::TwitterServer::Helpers only has a single render method
  # that delegates to the given renderer for the request format.
  # Assume the renderers know how to do their thing.
  def self.xml_renderer
    @xml_renderer || Renderer::NokogiriRenderer
  end

  module Renderer
    autoload :NokogiriRenderer, 'renderers/nokogiri_renderer'
  end
end

module Sinatra
  module TwitterServer
    module Helpers
      def api_options(*keys)
        options = {}
        options[:auth] = @auth if @auth
        keys.inject(options) do |memo, key|
          params.include?(key.to_s) ? memo.update(key => params[key]) : memo
        end
      end

      def render_xml_statuses(statuses)
        render_xml(:statuses) do |r|
          statuses.each do |st|
            r.node(:status) do
              r.status(st)
            end
          end
        end
      end

      def render_xml_user(user)
        render_xml(:user) do |r|
          r.user(user)
        end
      end

      def render_xml(root)
        ::TwitterServer.xml_renderer.new(root) do |renderer|
          yield renderer
        end.to_s
      end
    end

    def self.registered(app)
      app.helpers Sinatra::TwitterServer::Helpers
    end

    def twitter_basic_auth
      before do
        if base64 = env['HTTP_AUTHORIZATION']
          user, pass = Base64.decode64(base64.gsub(/Basic /, '')).split(":")
          @auth = yield user, pass
        end
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-home_timeline
    def twitter_statuses_home_timeline
      get "/statuses/home_timeline.:format" do
        options  = api_options(:since_id, :max_id, :count, :page)
        format   = params[:format]
        statuses = yield options
        render_xml_statuses(statuses)
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-friends_timeline
    def twitter_statuses_friends_timeline
      get "/statuses/friends_timeline.:format" do
        options  = api_options(:since_id, :max_id, :count, :page)
        format   = params[:format]
        statuses = yield options
        render_xml_statuses(statuses)
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline
    def twitter_statuses_user_timeline
      get "/statuses/user_timeline.:format" do
        options  = api_options(:user_id, :screen_name, :since_id, :max_id, :count, :page)
        format   = params[:format]
        statuses = yield options
        render_xml_statuses(statuses)
      end

      get "/statuses/user_timeline/:id.:format" do
        options  = api_options(:id, :user_id, :screen_name, :since_id, :max_id, :count, :page)
        format   = params[:format]
        statuses = yield options
        render_xml_statuses(statuses)
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-users%C2%A0show
    def twitter_users_show
      get "/users/show.:format" do
        options = api_options(:user_id, :screen_name)
        format  = params[:format]
        user    = yield options
        render_xml_user(user)
      end

      get "/users/show/:id.:format" do
        options = api_options(:id)
        format  = params[:format]
        user    = yield options
        render_xml_user(user)
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0verify_credentials
    def twitter_account_verify_credentials
      get "/account/verify_credentials.:format" do
        format  = params[:format]
        options = api_options
        user    = yield options
        render_xml_user(user)
      end
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-help%C2%A0test
    HELP_XML_RESPONSE = '<ok>true</ok>'.freeze
    HELP_RESPONSE     = 'ok'.freeze
    def twitter_help
      get "/help/test.:format" do
        params[:format] == 'xml' ? HELP_XML_RESPONSE : HELP_RESPONSE
      end
    end
  end

  register TwitterServer
end