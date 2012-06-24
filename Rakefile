#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :build do
  task :parser do
    system "racc lib/myson.y -o lib/myson/generated_parser.rb -g"
  end
end

task :rspec => "build:parser" do
  system "rspec"
end

task :default => :rspec
