# frozen_string_literal: true

require_relative '../actions'

# Install dependencies
class Orihon::Actions::DependenciesInstall < Orihon::Actions::BaseAction
  def call
    vendorer.call(update: false)
  end

  protected

  # @return [Orihon::Services::Vendorer]
  def vendorer
    ::Orihon.services.fetch(:vendorer).then do |service|
      service.new(config: config) if service.is_a?(Class)

      unless check?(service, ::Orihon::Services::Vendorer)
        raise "Incompatible type (got: #{service.class})"
      end

      service
    end
  end

  # Check given service against given type.
  #
  # @param service [Object, Class]
  # @param type [Class]
  #
  # @return [Boolean]
  def check?(service, type)
    [service.is_a?(type), service == type].include?(true)
  end
end
