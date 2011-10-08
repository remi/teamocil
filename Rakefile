desc "Run specs"
task :spec do # {{{
  sh "bundle exec rspec --color --format=nested #{File.join(File.dirname(__FILE__), "spec/layout.rb")}"
end # }}}

desc "Generate documentation"
task :doc do # {{{
  sh "bundle exec yard doc"
end # }}}
