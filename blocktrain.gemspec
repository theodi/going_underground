# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blocktrain/version'

Gem::Specification.new do |spec|
  spec.name          = 'blocktrain'
  spec.version       = Blocktrain::VERSION
  spec.authors       = ['pikesley', 'pkqk']
  spec.email         = ['ops@theodi.org']

  spec.summary       = %q{Train train train}
  spec.description   = %q{Train of fools}
  spec.homepage      = 'http://github.org/theodi/blocktrain'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv', '~> 2.0'
  spec.add_dependency 'curb', '~> 0.8'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rspec-pride', '~> 3.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1.6'
  spec.add_development_dependency 'git', '~> 1.2'
  spec.add_development_dependency 'github_changelog_generator', '~> 1.9'
  spec.add_development_dependency 'semver2', '~> 3.4'
end
