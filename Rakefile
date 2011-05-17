require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new

task :default => :spec

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
