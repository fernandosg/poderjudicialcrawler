require_relative 'lib/poderjudicial/version'

Gem::Specification.new do |spec|
  spec.name          = "poderjudicial"
  spec.version       = Poderjudicial::VERSION
  spec.authors       = ["Fer"]
  spec.email         = ["Fernando Segura"]

  spec.summary       = %q{Prueba crawler para obtener información del sitio del poder judicial}
  spec.description   = %q{Prueba crawler para obtener información del sitio del poder judicial}
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  #spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
   # `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #end
  spec.files = [
    "lib/poderjudicial/crawler_info"
  ]
  spec.add_runtime_dependency('watir')
  spec.add_runtime_dependency("webdrivers")
  spec.add_runtime_dependency("selenium-webdriver")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
