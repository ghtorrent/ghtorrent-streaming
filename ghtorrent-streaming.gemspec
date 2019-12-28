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
  spec.homepage      = 'https://github.com/streaming/streaming-streaming'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'azure'
  spec.add_development_dependency 'bunny'
  spec.add_development_dependency 'mongo', '~> 2.11'
  spec.add_development_dependency 'google-cloud-pubsub'
end
