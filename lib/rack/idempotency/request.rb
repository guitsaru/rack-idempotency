require "rack/request"

module Rack
  class Idempotency
    class Request < Rack::Request
      def idempotency_key
        get_header("HTTP_IDEMPOTENCY_KEY")
      end
    end
  end
end
