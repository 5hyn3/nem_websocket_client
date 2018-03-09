
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nem_websocket_client/version"

Gem::Specification.new do |spec|
  spec.name          = "nem_websocket_client"
  spec.version       = NemWebsocketClient::VERSION
  spec.authors       = ["shyne"]
  spec.email         = ["shyne9795@gmail.com"]

  spec.summary       = %q{NEM's WebSocket Client.}
  spec.description   = %q{This is NEM's WebSocket client.t will be able to handle NEM's WebSocket API without knowledge of WebSocket or STOMP.}
  spec.homepage      = "https://github.com/5hyn3/nem_websocket_client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "stomp_parser", "~>1.0.0"
  spec.add_dependency "websocket-client-simple", "~>0.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "eventmachine", "~>1.2.5"
end
