require "bundler/gem_tasks"

desc "Run specs"
task :spec do # {{{
  sh "bundle exec rspec --color --format=nested #{Dir.glob(File.join(File.dirname(__FILE__), "spec/**/*_spec.rb")).join(" ")}"
end # }}}

desc "Generate documentation"
task :doc do # {{{
  sh "bundle exec yard doc"
end # }}}
