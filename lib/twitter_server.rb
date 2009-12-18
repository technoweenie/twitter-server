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

    autoload :Help, 'sinatra/twitter_server/help'
  end

  helpers Sinatra::TwitterServer::Helpers
end