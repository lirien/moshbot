require 'rspec/core/rake_task'
require 'rubocop/rake_task'
RSpec::Core::RakeTask.new(:spec)

task test: :spec
task default: [:spec, :rubocop]

task :rubocop do
  RuboCop::RakeTask.new
end
