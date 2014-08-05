require 'bundler'
require 'rake'
require 'bundler/gem_tasks'

desc 'Start an IRB session with the gem'
task :console do
  $:.unshift File.expand_path('..', __FILE__)
  require 'teamocil'
  require 'irb'

  ARGV.clear
  IRB.start
end
