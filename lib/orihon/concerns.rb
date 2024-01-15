# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Concerns
  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    {
      Registry: :registry,
    }.each { autoload(_1, "#{path}/#{_2}") }
  end
end
