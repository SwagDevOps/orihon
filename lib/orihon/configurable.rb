# frozen_string_literal: true

require_relative '../orihon'

# @abstract
class Orihon::Configurable
  # @param [Orihon::Config]
  def initialize(config: nil)
    @config = config || lambda do
      Object.const_get(:ORIHON_CONFIG)
    rescue StandardError => e
      missing_config(error: e)
    end.call
  end

  protected

  # @return [Orihon::Config]
  attr_reader :config

  # @param error [Exception]
  #
  # @return [Orihon::Config]
  def missing_config(error: nil)
    if error.is_a?(::Exception)
      [
        "#{error.class.name}: #{error.message}",
        "#{error.backtrace_locations[0]}"
      ].join("\n").strip.tap { warn(_1) }
    end

    ::Orihon::Config.allocate
  end
end
