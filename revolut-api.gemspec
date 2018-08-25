
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "revolut/api/version"

Gem::Specification.new do |spec|
  spec.name          = "revolut-api"
  spec.version       = Revolut::Api::VERSION
  spec.authors       = ["Sebastian Johnsson"]
  spec.email         = ["sebastian.johnsson@gmail.com"]

  spec.summary       = %q{Ruby API client for interacting with Revolut's consumer API}
  spec.description   = %q{Ruby client for interacting with Revolut's consumer API (user data, transactions, exchange etc.)}
  spec.homepage      = "https://github.com/SebastianJ/revolut-api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
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
  
  spec.add_dependency "faraday",                ">= 0.15"
  spec.add_dependency "faraday_middleware",     ">= 0.12"
  
  spec.add_development_dependency "bundler",    "~> 1.16"
  spec.add_development_dependency "rake",       "~> 10.0"
  spec.add_development_dependency "rspec",      "~> 3.0"
  spec.add_development_dependency "rdoc",       "~> 6.0"
  spec.add_development_dependency "vcr",        "~> 4.0"
  spec.add_development_dependency "webmock",    "~> 3.1"
  
  spec.add_development_dependency "pry",        "~> 0.11"
end
