# Rack::Idempotency

Rack middleware ensuring at most once requests for mutating endpoints.

Inspired by [this stripe blog post](https://stripe.com/blog/idempotency).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rack-idempotency"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-idempotency

## Server Usage

Rack::Idempotency is implemented as a piece of Rack middleware and can be used with any Rack-based application. If your application includes a rackup (.ru) file or uses Rack::Builder to construct the application pipeline, simply require and use as follows:

```ruby
require "rack/idempotency"

use Rack::Idempotency, store: Rack::Idempotency::MemoryStore.new

run app
```

The `store` argument should be any object that responds to both `read(id)` and `write(id, value)`.  `Rack::Idempotency::MemoryStore` is good for testing, but should not be used in production.

## Using with Rails

```ruby
config.middleware.use Rack::Idempotency, store: Rails.cache
```

## Client Usage

Rack::Idempotency works with any client that sets an `Idempotency-Key` header.  If the request succeeds, any subsequent request with the same key will return a cached response.

## Considerations

Rack::Idempotency should handle the following cases:

 - [x] The initial connection to the server fails.
 - [ ] The request fails halfway through, leaving data in limbo.
 - [x] The request succeeds, but the connection to the client is lost.
 
The second case is much more dependent on implementation.  Rack::Idempotency assumes that the request is in a transaction and
can be safely retried if it wasn't successful.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/guitsaru/rack-idempotency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

