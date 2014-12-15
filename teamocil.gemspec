# encoding: utf-8

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'teamocil/version'

Gem::Specification.new do |s|
  # Metadata
  s.name         = 'teamocil'
  s.version      = Teamocil::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = 'Rémi Prévost'
  s.email        = 'remi@exomel.com'
  s.homepage     = 'http://www.teamocil.com'
  s.license      = 'MIT'
  s.description  = 'Teamocil is a simple tool used to automatically create windows and panes in tmux with YAML files.'
  s.summary      = s.description

  # Manifest
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  # Dependencies
  s.required_ruby_version = '>= 2.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'phare', '~> 0.6'
  s.add_development_dependency 'rubocop', '0.26.1'
  s.add_development_dependency 'rspec', '~> 3.0'
end
