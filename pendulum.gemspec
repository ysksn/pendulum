# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pendulum/version'

Gem::Specification.new do |spec|
  spec.name          = "pendulum"
  spec.version       = Pendulum::VERSION
  spec.authors       = ["monochromegane"]
  spec.email         = ["dev.kuro.obi@gmail.com"]

  spec.summary       = %q{Pendulum is a tool to manage Treasure Data scheduled jobs.}
  spec.description   = %q{Pendulum is a tool to manage Treasure Data scheduled jobs.}
  spec.homepage      = "https://github.com/monochromegane/pendulum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "td"
  spec.add_dependency "td-client"
  spec.add_dependency "hashie"
  spec.add_dependency "highline"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
