Gem::Specification.new do |spec|
  spec.name          = "lita-howlongtobeat"
  spec.version       = "0.4.0"
  spec.authors       = ["Magnus Skog"]
  spec.email         = ["magnus.m.skog@gmail.com"]
  spec.description   = "A Lita handler that returns the average number of hours required to beat a game from http://howlongtobeat.com"
  spec.summary       = "A Lita handler that returns the average number of hours required to beat a game from http://howlongtobeat.com"
  spec.homepage      = "https://github.com/mskog/lita-howlongtobeat"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 4.7"
  spec.add_runtime_dependency "nokogiri", ">= 1.6.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'fakeredis', '~> 0.5.0'
end
