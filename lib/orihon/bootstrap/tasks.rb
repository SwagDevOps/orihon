# frozen_string_literal: true

require_relative('boot')

# tasks ---------------------------------------------------------------
::File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
  ::Dir.glob("#{path}/**/*.rb")
       .sort
       .each { require(_1) }
end
