require "rack/request"

module Rack
  class Idempotency    
    class Request < Rack::Request
      def idempotency_key
        get_header("HTTP_IDEMPOTENCY_KEY").tap do |key|
          unless key.nil? || key.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i)
            raise InsecureKeyError.new(env), 'Idempotency-Key must be a valid UUID'
          end
        end
      end
    end
  end
end
