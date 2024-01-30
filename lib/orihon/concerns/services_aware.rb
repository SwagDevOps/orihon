# frozen_string_literal: true

require_relative '../concerns'

module Orihon::Concerns::ServicesAware
  protected

  # @return [Hash{Symbol => Orihon::Services::BaseService}]
  def services
    ::Orihon.app.__send__(:services)
  end
end
