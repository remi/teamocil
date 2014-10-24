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
  s.homepage     = 'http://remiprev.github.com/teamocil'
  s.license      = 'MIT'
  s.summary      = 'Easy session, window and pane layouts for tmux'
  s.description  = 'Teamocil helps you set up window and pane layouts for tmux using YAML configuration files.'

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
