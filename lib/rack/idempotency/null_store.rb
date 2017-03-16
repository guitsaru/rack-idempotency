module Rack
  class Idempotency
    # Basic version of the store.  This class doesn't read or write.
    class NullStore
      def read(_id); end

      def write(_id, _value); end
    end
  end
end
