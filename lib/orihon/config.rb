# frozen_string_literal: true

require_relative '../orihon'

class Orihon::Config
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  def initialize(file, defaults_provider: nil)
    # @type [Orihon::Services::DefaultsProvider, Class<Orihon::Services::DefaultsProvider>]
    defaults_provider ||= ::Orihon.services.fetch(:defaults_provider)
    # @type [Hash{Symbol => Object}]
    defaults = defaults_provider.call

    Pathname.new(file).realpath.read.then do |content|
      @config = yaml(content, defaults: defaults)
    end
  end

  # @return [Hash{Symbol => Object}]
  def to_h
    self.config.dup.transform_values(&:dup)
  end

  def fetch(...)
    self.to_h.fetch(...)
  end

  # @param key [String, Symbol]
  #
  # @return [Pathname]
  def path(key)
    self.to_h.fetch(key.to_sym).then do |value|
      Pathname.pwd.join(value.to_s).freeze
    end
  end

  protected

  # @return [Hash{Symbol => Object}]
  attr_reader :config

  # @param content [String]
  # @param defaults [Hash{Symbol => Object}]
  #
  # @return [Hash{Symbol => Object}]
  def yaml(content, defaults: {})
    YAML.safe_load(content, aliases: true)
        .to_h
        .transform_keys(&:to_sym)
        .then { defaults.merge(_1) }
  end
end
