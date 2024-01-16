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
    # noinspection RubyMismatchedReturnType
    ::Orihon.services.fetch(:vendorer).tap do |service|
      if service.is_a?(Class)
        # @type [Class<Orihon::Configurable>]
        service.new(config: config)
      end
    end
  end
end
