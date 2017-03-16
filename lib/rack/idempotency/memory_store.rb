module Rack
  class Idempotency
    # Stores idempotency information in a Hash.
    class MemoryStore
      def initialize
        @store = {}
      end

      def read(id)
        store[id]
      end

      def write(id, value)
        store[id] = value
      end

      private

      attr_reader :store
    end
  end
end
