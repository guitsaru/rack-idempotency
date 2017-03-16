module Rack
  class Idempotency
    class RequestStorage
      def initialize(store, request)
        @store   = store
        @request = request
      end

      def read
        return unless request.idempotency_key

        stored = store.read(storage_key)
        JSON.parse(stored) if stored
      end

      def write(response)
        return unless request.idempotency_key

        store.write(storage_key, response.to_json)
      end

      private

      attr_reader :request
      attr_reader :store

      def storage_key
        "rack:idempotency:" + request.idempotency_key
      end
    end
  end
end
