# frozen_string_literal: true

require_relative '../services'

class Orihon::Services::Template < Orihon::Services::BaseService
  # Renderder given ``source`` with given ``variables``.
  #
  # @param source [String]
  # @param variables [Hash{Symbol => Object}]
  #
  # @return [String]
  def call(source, variables = {}, dialect: :html)
    engine_for(dialect).render(source, variables || {})
  end

  protected

  # @see https://github.com/enspirit/wlang
  #
  # @return [Class<Wlang::Dialect>]
  def engine_for(dialect)
    engines.fetch(dialect.to_sym)
  end

  # @return [Hash{Symbol => Class<Wlang::Dialect>}]
  def engines
    ::Orihon::Templates.all
  end
end
