# frozen_string_literal: true

require_relative '../services'

# Provides documented & cached dependencies (with automatic updates).
#
# @see https://github.com/grosser/vendorer
class Orihon::Services::Vendorer < Orihon::Services::BaseService
  # @param update [Boolean]
  #
  # @return [Array]
  def call(update: false)
    self.parameters.then do |parameters|
      return [] if parameters.empty?

      self.vendorer(update: update).then do |vendorer|
        parameters.map do |params|
          vendorer.public_send(*params).then { params }
        end
      end
    end
  end

  protected

  # Get key (for dependencies config).
  #
  # @return [Symbol]
  def dependencies_key
    :dependencies
  end

  # Get an array of parameters-array.
  #
  # @return [Array<Array<String, Hash>>]
  def parameters
    config.fetch(dependencies_key, {})
          .to_h
          .then { Transformer.new.call(_1) }
  end

  # Instanciate an instance.
  #
  # @param update [Boolean]
  #
  # @return [Vendorer]
  def vendorer(update: :false)
    autoload(:Vendorer, 'vendorer')

    Vendorer.new({ update: update })
  end
end

# Transformer for dependencies.
#
# Transforms from (value from config):
# ```
# {
#   'path/to/awesome-project/' => {
#     'url' => 'https://github.com/Awesome/Project',
#     'branch' => 'master',
#   },
#   'path/to/jquery.min.js' => {
#     'url' => 'http://code.jquery.com/jquery-latest.min.js',
#     'type' => 'file',
#   }
# }
# ```
# to:
# ```
#  [['folder',
#    'path/to/awesome-project/',
#    'https://github.com/Awesome/Project',
#    {:branch=>"master"}],
#   ['file',
#    'path/to/'jquery.min.js',
#    'http://code.jquery.com/jquery-latest.min.js']]
# ```
class Orihon::Services::Vendorer::Transformer
  autoload(:Pathname, 'pathname')

  #
  # @return [Array<Array<String, Hash>>]
  def call(payload)
    payload
      .to_h
      .then { self.prepare(_1) }
      .then { self.transform(_1) }
      .then { self.parameterize(_1) }
  end

  protected

  # @param [Array<Hash{Symbol => Object}>] payload
  #
  # @return [Array<Array<String, Hash>>]
  def parameterize(payload)
    payload.map do |h|
      [
        h.fetch(:type),
        Pathname.new(h.fetch(:path).to_s).then { |path| path.absolute? ? path : Pathname.pwd.join(path) },
        h.fetch(:url),
      ].map(&:to_s).then do |params|
        h[:type] == 'folder' ? params.concat([h.fetch(:options, {}).to_h]) : params
      end
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  # Transform values seen in YAML manifest.
  #
  # @param [Array<Hash{Symbol => Object}>] payload
  #
  # @return [Array<Hash{Symbol => Object}>]
  def transform(payload)
    payload.map do |h|
      h.tap { h[:options] = (h[:options] || {}).transform_keys(&:to_sym) if h[:options] }
    end.map do |h|
      h.tap do
        if (h[:options] || {}).empty?
          [:ref, :tag, :branch].each do |k|
            h[:options] = (h[:options] || {}).merge({ k => h[k] }) if h[k]
            h.delete(k)
          end
        end
      end
    end.map { |h| h.sort_by { |k, _| k }.to_h }
  end

  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity

  # @param [Array<Hash{Symbol => Object}>, nil] payload
  #
  # @return [Array<Hash{Symbol => Object}>]
  def prepare(payload)
    # options hash is present depending on type folder - type folder is implicit and preferred
    f = lambda do |h|
      (h[:type] || 'folder').then do |type|
        %w[folder dir directory].include?(type) ? 'folder' : type
      end.then do |type|

        {
          type: type,
          options: type == 'folder' ? h.fetch(:options, {}) : nil,
        }.compact.then { |v| h.merge(v) }
      end
    end

    (payload || {})
      .map { |k, v| v.merge({ path: k }) }
      .map { |h| h.transform_keys(&:to_sym) }
      .keep_if { |h| ![h[:path], h[:url]].map(&:to_s).include?('') }
      .map { |h| f.call(h) }
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
end
