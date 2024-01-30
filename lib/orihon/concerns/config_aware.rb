# frozen_string_literal: true

require_relative '../concerns'

module Orihon::Concerns::ConfigAware
  protected

  # @return [Orihon::Config]
  def config
    ::Orihon.app.__send__(:config)
  end
end
