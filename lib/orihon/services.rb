# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Services
  class << self
    include(::Orihon::Concerns::Registry)
  end

  File.realpath(__FILE__).gsub(/\.rb/, '').tap do |path|
    {
      BaseService: :base_service,
      DefaultsProvider: :defaults_provider,
      Info: :info,
      Structurizer: :structurizer,
      Template: :template,
      Vendorer: :vendorer,
    }.then { register(_1, path: path) }.then do |h|
      self.define_singleton_method(:all) do
        h.map { [_1, self.const_get(_2)] }.to_h
      end
    end
  end
end
