# frozen_string_literal: true

require_relative '../services'

class Orihon::Services::Template < Orihon::Services::BaseService
  # Renderder given ``source`` with given ``variables``.
  #
  # @param source [String]
  # @param variables [Hash{Symbol => Object}]
  #
  # @return [String]
  def call(source, variables)
    engine.parse(source, error_mode: :strict).then do |template|
      template.render!(variables.transform_keys(&:to_s), render_config).tap do
        warn(template.errors) unless template.errors.empty?
      end
    end
  end

  protected

  # @return [Class<Liquid::Template>]
  def engine
    require('liquid').then { Liquid::Template }
  end

  # @return [Hash{Symbol => Boolean}]
  def render_config
    {
      strict_variables: true,
      strict_filters: true,
    }
  end
end
