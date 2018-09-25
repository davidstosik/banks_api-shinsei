require "banks_api/shinsei/js_parser"

module BanksApi
  module Shinsei
    class FaradayMiddleware < Faraday::Middleware
      def call(request_env)
        request_env.body.force_encoding(Encoding::ASCII_8BIT)
        request_env.request_headers["User-Agent"] = USER_AGENT

        @app.call(request_env).on_complete do |response_env|
          # #toutf8 converts half-width Katakana to full-width (???)
          # As recommended in the official Ruby documentation (see link below),
          # we'll use this instead.
          # https://docs.ruby-lang.org/ja/2.4.0/method/Kconv/m/toutf8.html
          response_env.body = NKF.nkf("-wxm0", response_env.body)

          if response_env.response_headers["content-type"]&.match?(/text\/html/)
            response_env.body = JsParser.data_for(response_env.body)
          end
        end
      end

      USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 5.1;) PowerDirectBot/0.1".freeze
      private_constant :USER_AGENT
    end
  end
end
