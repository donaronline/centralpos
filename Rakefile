require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: [:test]

task :console do
  require "pry"
  require "./lib/centralpos"
  require "httplog"

  def reload!
    files = $LOADED_FEATURES.select { |feat| feat =~ %r{lib/centralpos} }
    # Deactivate warning messages.
    original_verbose, $VERBOSE = $VERBOSE, nil
    files.each { |file| load file }
    # Activate warning messages again.
    $VERBOSE = original_verbose
    "Console reloaded!"
  end

  ARGV.clear
  Pry.start
end
