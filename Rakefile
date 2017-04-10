require "bundler/gem_tasks"
require "rake/extensiontask"

CLEAN.include "ext/rhust/target"

task :build => :compile

Rake::ExtensionTask.new("rhust") do |ext|
  ext.lib_dir = "lib/rhust"
end
