# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Concerns
  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    {
      ActionsAware: :actions_aware,
      ConfigAware: :config_aware,
      Registry: :registry,
      ServicesAware: :services_aware,
    }.each { autoload(_1, "#{path}/#{_2}") }
  end
end
