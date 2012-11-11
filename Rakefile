require "bundler"
Bundler.require(:development)

require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "spec/**/*_spec.rb"
  task.rspec_opts = "--colour --format=documentation"
end

desc "Generate YARD Documentation"
YARD::Rake::YardocTask.new do |task|
  task.options = [
    "-o", File.expand_path("../doc", __FILE__),
    "--readme=README.md",
    "--markup=markdown",
    "--markup-provider=maruku",
    "--no-private",
    "--no-cache",
    "--protected",
    "--title=Teamocil",
  ]
  task.files   = ["lib/**/*.rb"]
end
