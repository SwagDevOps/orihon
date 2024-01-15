# frozen_string_literal: true

require_relative '../concerns'

# Concern for modules providing a registry based on its autoload.
module Orihon::Concerns::Registry
  protected

  # Register given autoloadables (as ``class_name``, ``file_name``).
  #
  # Get back a filtered list.
  #
  # @param autoloadables [Hash{Symbol => Symbol}] as ``class_name``, ``file_name``
  # @param path [String]
  # @param aliases [Hash{Symbol => Symbol}]
  #
  # @return [Hash{Symbol => Symbol}] as ``alias_name``, ``class_name``
  def register(autoloadables, path:, aliases: {})
    autoloadables.map do |class_name, file_name|
      autoload(class_name, "#{path}/#{file_name}")

      [file_name, class_name].tap do |result|
        result[1] = nil unless registry_keep?(file_name)
      end
    end.sort.to_h.compact.tap do |reg|
      aliases.each do |name, klass|
        if [reg.values.include?(klass.to_sym), reg.keys.include?(name.to_sym)] == [true, false]
          reg[name.to_sym] = klass.to_sym
        end
      end
    end
  end

  # Denote given name MUST be kept (in register result).
  #
  # @param [String, Symbol] name
  #
  # @return [Boolean]
  def registry_keep?(name)
    true.tap do
      registry_exclude_matcher&.tap do |matcher|
        return false if name.to_s.match?(matcher)
      end
    end
  end

  # @return [Regexp, nil]
  def registry_exclude_matcher
    /^base_.+/
  end
end
