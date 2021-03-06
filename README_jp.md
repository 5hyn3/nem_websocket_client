# NemWebsocketClient
[![Build Status](https://travis-ci.org/5hyn3/nem_websocket_client.svg?branch=master)](https://travis-ci.org/5hyn3/nem_websocket_client)

NemWebsocketClientはNEMのWebsocketを扱うためのシンプルなライブラリです。
## Installation

```ruby
gem install nem_websocket_client
```

## Usage

```ruby
require "nem_websocket_client"

host = "http://alice5.nem.ninja"
port = 7778
ws = NemWebsocketClient::connect(host,port)

ws.connected do
  p "Connected!"
end

ws.subscribe_block do |transaction|
  p transaction["timeStamp"]
end

ws.errors do |e|
  p e
end

ws.closed do |e|
  p e
end

loop do
  
end
```

## Test
```ruby
gem install bundler
bundle install
rspec
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/5hyn3/nem_websocket_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NemWebsocketClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nem_websocket_client/blob/master/CODE_OF_CONDUCT.md).

## Donation

開発者のモチベアップや、他のプロダクトの開発に役立てられます。

NEM
```
NCADQWTJUPTSDZ6XEIVIAR7GANIGJENVUAPN3OMD
```
