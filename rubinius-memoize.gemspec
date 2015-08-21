# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubinius/memoize/version'

Gem::Specification.new do |spec|
  spec.name          = "rubinius-memoize"
  spec.version       = Rubinius::Memoize::VERSION
  spec.authors       = ["Josep M. Bach"]
  spec.email         = ["me@txus.io"]
  spec.description   = %q{Memoize methods through Rubinius AST transforms}
  spec.summary       = %q{Memoize methods through Rubinius AST transforms}
  spec.homepage      = "https://github.com/txus/rubinius-memoize"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubinius-ast"
  spec.add_runtime_dependency "rubinius-toolset"
  spec.add_runtime_dependency "rubinius-compiler"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency "rubysl-singleton"
  spec.add_development_dependency "rake"
end
