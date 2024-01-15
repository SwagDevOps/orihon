# frozen_string_literal: true

require_relative '../services'

class Orihon::Services::Structurizer < Orihon::Services::BaseService
  # @param value [Hash{Symbol, String => Object}]
  #
  # @return [Struct]
  def call(value)
    value.transform_keys(&:to_sym).then do |h|
      ::Struct.new(*h.keys).new(*h.values)
    end
  end
end
