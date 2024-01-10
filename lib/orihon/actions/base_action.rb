# frozen_string_literal: true

require_relative '../actions'

# @abstract
class Orihon::Actions::BaseAction < Orihon::Configurable
  autoload(:FileUtils, 'fileutils')
  autoload(:Shellwords, 'shellwords')

  # Execute the action
  def call
  end

  class << self
    def call
      self.new.call
    end
  end

  protected

  # @return [Boolean]
  def debug?
    config.fetch(:tasks_debug).then do |v|
      return v if v.is_a?(TrueClass) or v.is_a?(FalseClass)

      !!(v)
    end
  end

  # @return [Module<FileUtils>]
  def fs
    # noinspection RubyMismatchedReturnType
    debug? ? FileUtils::Verbose : FileUtils
  end

  # @param command [Array<String, Pathname>]
  #
  # @return [Boolean]
  def sh(command)
    with_command(command) do |c|
      system(*c, exception: true) || false
    end
  end

  # @param [Array<String, Pathname>] command
  #
  # @return [Boolean]
  def detach(command)
    true.tap do
      with_command(command) do |c|
        ::Process.fork { ::Kernel.exec(*c) }
      end
    end
  end

  # Process given command.
  #
  # @param command [Array<String, Pathname>]
  # @yield [c]
  # @yieldparam c [Array<String>]
  def with_command(command, &block)
    # noinspection RubyMismatchedReturnType
    command
      .map { |v| v.is_a?(Pathname) ? v.to_s : v }
      .tap { |items| warn(Shellwords.join(items)) if debug? }
      .then { block ? block.call(_1) : _1 }
  end
end
