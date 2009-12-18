require 'sinatra/base'
require 'active_support/core_ext/hash'

module TwitterServer
end

module Sinatra
  module TwitterServer
    module Helpers
      def api_options(*keys)
        options = params.slice(*keys.map! { |k| k.to_s })
        options.symbolize_keys!
        options
      end
    end

    def self.registered(app)
      app.helpers Sinatra::TwitterServer::Helpers
    end

    # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-help%C2%A0test
    def twitter_help
      get "/help/test.:format" do
        options = api_options(:format)
        yield(options)
      end
    end
  end
end