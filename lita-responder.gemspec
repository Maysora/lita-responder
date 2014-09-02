Gem::Specification.new do |spec|
  spec.name          = "lita-responder"
  spec.version       = "0.0.2"
  spec.authors       = ["Roy Hadrianoro"]
  spec.email         = ["dev@maysora.com"]
  spec.description   = %q{A Lita handler for responding using saved key-value or optionally using cleverbot}
  spec.summary       = %q{A Lita handler for responding using saved key-value or optionally using cleverbot}
  spec.homepage      = "https://github.com/Maysora/lita-responder"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.3"
  spec.add_runtime_dependency "lita-exclusive-route"
  spec.add_runtime_dependency "cleverbot"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
