# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "teamocil"

spec = Gem::Specification.new do |s|
  s.name         = "teamocil"
  s.version      = Teamocil::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = "Rémi Prévost"
  s.email        = "remi@exomel.com"
  s.homepage     = "http://github.com/remiprev/teamocil"
  s.summary      = "Easy window and split layouts for tmux"
  s.description  = "Teamocil helps you set up window and splits layouts for tmux using YAML configuration files."
  s.files        = Dir["lib/**/*.rb", "README.md", "LICENSE", "bin/*", "spec/**/*.rb"]
  s.require_path = "lib"
  s.executables << "teamocil"

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("yard")
  s.add_development_dependency("maruku")

end
