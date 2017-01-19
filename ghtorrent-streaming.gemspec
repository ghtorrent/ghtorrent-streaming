# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'streaming-streaming'
  spec.version       = GHTorrent::Streaming::VERSION
  spec.authors       = ['Georgios Gousios']
  spec.email         = ['gousiosg@gmail.com']

  spec.summary       = 'Streaming updates from the GHTorrent databases'
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/streaming/streaming-streaming'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'azure'
  spec.add_development_dependency 'bunny'
  spec.add_development_dependency 'mongo', '~> 1.12.5'
  spec.add_development_dependency 'bson_ext', '~> 1.12.5'
  spec.add_development_dependency 'mongoriver'
  spec.add_development_dependency 'google-cloud-pubsub'
end
