
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "banks_api/shinsei/version"

Gem::Specification.new do |spec|
  spec.name          = "banks_api-shinsei"
  spec.version       = BanksApi::Shinsei::VERSION
  spec.authors       = ["David Stosik"]
  spec.email         = ["david.stosik+git-noreply@gmail.com"]

  spec.summary       = %q{BanksAPI implementation for Shinsei Bank accounts}
  spec.description   = %q{BanksAPI implementation for Shinsei Bank accounts}
  spec.homepage      = "https://github.com/davidstosik/banks_api-shinsei"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "banks_api", "~> 0.1"
  spec.add_dependency "faraday", "~> 0.15"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
