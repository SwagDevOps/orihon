# frozen_string_literal: true

require_relative '../orihon'

# @abstract
class Orihon::Configurable
  include(::Orihon::Concerns::ConfigAware)

  # @param [Orihon::Config]
  def initialize(config: nil)
    @config = config
  end

  protected

  # Config SHOULD be used on runtime (``call`` method).
  #
  # @return [Orihon::Config]
  def config
    (@config || super).tap do |config|
      raise ::RuntimeError, 'Missing config' unless config
    end
  end
end
