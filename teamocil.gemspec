spec = Gem::Specification.new do |s|
  s.name         = "teamocil"
  s.version      = "0.1.10"
  s.platform     = Gem::Platform::RUBY
  s.authors      = "Rémi Prévost"
  s.email        = "remi@exomel.com"
  s.homepage     = "http://github.com/remiprev/teamocil"
  s.summary      = "Easy window and split layouts for tmux"
  s.description  = "Teamocil helps you set up window and splits layouts for tmux using YAML configuration files."
  s.files        = Dir["lib/**/*.rb", "README.mkd", "LICENSE", "bin/*", "spec/**/*.rb"]
  s.require_path = "lib"
  s.executables << "teamocil"

  s.add_development_dependency("rspec")

end
