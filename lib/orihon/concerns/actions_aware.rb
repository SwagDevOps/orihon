# frozen_string_literal: true

require_relative '../concerns'

module Orihon::Concerns::ActionsAware
  protected

  # @return [Hash{Symbol => Orihon::Actions::BaseAction}]
  def actions
    ::Orihon.app.__send__(:actions)
  end
end
