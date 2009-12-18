module Sinatra
  module TwitterServer
    module Help
      def twitter_help
        get "/help/test.:format" do
          options = api_options(:format)
          yield(options)
        end
      end
    end
  end

  register TwitterServer::Help
end