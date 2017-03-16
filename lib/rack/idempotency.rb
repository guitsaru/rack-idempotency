require "json"

require "rack/idempotency/version"

require "rack/idempotency/memory_store"
require "rack/idempotency/null_store"
require "rack/idempotency/request"
require "rack/idempotency/request_storage"
require "rack/idempotency/response"

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
      @env     = env
      @request = Request.new(env.dup.freeze)

      lookup || store_response
    end

    private

    attr_reader :app
    attr_reader :env
    attr_reader :request
    attr_reader :store

    def request_store
      @request_store ||= RequestStorage.new(store, request)
    end

    def lookup
      request_store.read
    end

    def store_response
      response = Response.new(*@app.call(env))

      request_store.write(response) if response.success?

      response.to_a
    end
  end
end
