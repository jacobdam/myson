#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :build do
  task :parser do
    system "racc lib/myson.y -o lib/myson/generated_parser.rb -g"
  end
end

task :spec do
  system "rspec"
end

task :default => ["build:parser", "spec"]
