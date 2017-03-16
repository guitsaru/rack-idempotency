module Rack
  class Idempotent
    # Basic version of the store.  This class doesn't read or write.
    class NullStore
      def read(_id)
        nil
      end

      def write(_id, _value)
        nil
      end
    end
  end
end
