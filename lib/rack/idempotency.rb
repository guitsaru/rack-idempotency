require "json"

require "rack/idempotency/version"

require "rack/idempotency/memory_store"
require "rack/idempotency/null_store"

module Rack
  # Rack middleware for ensuring mutating endpoints are called at most once.
  #
  # Any request with an `Idempotency-Key` header will store its response in
  # the given cache.  When the client retries, it will get the previously
  # cached response.
  class Idempotency
    def initialize(app, store: NullStore.new)
      @app     = app
      @store   = store
    end

    def call(env)
      idempotency_key = env["HTTP_IDEMPOTENCY_KEY"]
      storage_key     = generate_storage_key(idempotency_key)
      stored          = store.read(storage_key)
      return JSON.parse(stored) if stored

      response = @app.call(env)
      store_response(storage_key, response)

      response
    end

    private

    attr_reader :app, :store

    def store_response(storage_key, response)
      if successful?(response)
        marshaled_response = response.to_json
        store.write(storage_key, marshaled_response)
      end

      response
    end

    def successful?(response)
      status = response.first

      # Treat redirects as a successful response.
      status.to_i >= 200 && status.to_i < 400
    end

    def generate_storage_key(idempotency_key)
      namespace = "rack:idempotency"

      [namespace, idempotency_key.to_s].join(":")
    end
  end
end
