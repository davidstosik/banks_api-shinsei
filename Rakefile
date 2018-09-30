$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "banks_api/shinsei/version"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :build do
  system "gem build banks_api-shinsei.gemspec"
end

task release: :build do
  system "gem push pkg/banks_api-shinsei-#{BanksApi::Shinsei::VERSION}.gem"
end

task :default => :test
