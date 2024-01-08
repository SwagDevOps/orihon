# frozen_string_literal: true

require_relative 'vendor/bundle/bundler/setup.rb'
require('sys/proc').then { Sys::Proc.progname = nil }
$:.unshift File.expand_path("#{__dir__}/lib")
# main ----------------------------------------------------------------
require_relative 'dev/rake'
# default task --------------------------------------------------------
task default: ['gem:gemspec']
