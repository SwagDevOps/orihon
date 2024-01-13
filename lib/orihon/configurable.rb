# frozen_string_literal: true

require_relative '../orihon'

# @abstract
class Orihon::Configurable
  # @param [Orihon::Config]
  def initialize(config: nil)
    @config = config || lambda do
      :ORIHON_CONFIG.then do |c|
        Object.constants.include?(c) ? Object.const_get(c) : nil
      end
    end.call
  end

  protected

  # Config SHOULD be used on runtime (``call`` method).
  #
  # @return [Orihon::Config]
  def config
    return @config unless @config.nil?

    raise ::RuntimeError, 'Missing config'
  end
end
