# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Services
  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    {
      BaseService: :base_service,
      DefaultsProvider: :defaults_provider,
      Info: :info,
      Structurizer: :structurizer,
      Template: :template,
    }.map do |k, v|
      autoload(k, "#{path}/#{v}").then { [k, v] }
    end.then do |h|
      self.define_singleton_method(:all) do
        h.map { |k, v| [v, self.const_get(k)] }.to_h
      end
    end
  end
end
