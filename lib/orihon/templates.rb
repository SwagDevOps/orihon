# frozen_string_literal: true

require_relative '../orihon'

# Provides templates engines (dialects).
#
# @see https://github.com/enspirit/wlang
module Orihon::Templates
  class << self
    include(::Orihon::Concerns::Registry)
  end

  File.realpath(__FILE__).gsub(/\.rb/, '').tap do |path|
    {
      BaseDialect: :base_dialect,
      Dummy: :dummy,
      Html: :html,
    }.then { register(_1, path: path) }.then do |h|
      self.define_singleton_method(:all) do
        require 'wlang'

        h.map { [_1, self.const_get(_2)] }.to_h
      end
    end
  end
end
