# frozen_string_literal: true

require_relative '../services'

class Orihon::Services::Structurizer < Orihon::Services::BaseService
  # @param value [Hash{Symbol, String => Object}]
  #
  # @return [Struct]
  def call(value)
    value.transform_keys(&:to_sym).then do |h|
      ::Struct.new(*h.keys).new(*h.values).then { liquify(_1) }
    end
  end

  protected

  # Add a ``#to_liquid`` method on given instance.
  #
  # @param instance [Struct]
  #
  # @return [Struct]
  def liquify(instance)
    instance.tap do
      _1.__send__(:define_singleton_method, :to_liquid) { to_h.transform_keys(&:to_s) }
    end
  end
end
