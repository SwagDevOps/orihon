# frozen_string_literal: true

require_relative('../orihon')

# Provides access to config, services and actions (for tasks).
class Orihon::TaskApp
  def initialize
    {
      actions: ::Orihon::Concerns::ActionsAware,
      config: ::Orihon::Concerns::ConfigAware,
      services: ::Orihon::Concerns::ServicesAware,
    }.map do |attr, mod|
      self.apply(attr, mod)
    end
  end

  # @return [Hash{Symbol => Orihon::Actions::BaseAction}]
  attr_reader :actions

  # @return [Orihon::Config]
  attr_reader :config

  # @return [Hash{Symbol => Orihon::Services::BaseService}]
  attr_reader :services

  # Define task.
  #
  # @param task_name [String, Symbol]
  # @param dependencies [Array<String, Symbol>]
  # @param args [Array<Symbol>]
  # @param desc [String]
  def task(task_name, dependencies = [], args: nil, desc: nil, &block)
    services.fetch(:tasker).then do |tasker|
      # @type tasker [Orihon::Services::Tasker]
      tasker.call(task_name, dependencies, args: args, desc: desc, &block)
    end
  end

  protected

  # @param mod [Module]
  # @param attr [Symbol]
  def apply(attr, mod)
    Class.new { include(mod) }.new.then do |c|
      c.__send__(attr)
    end.tap do |v|
      self.instance_variable_set("@#{attr}", v)
    end
  end
end

# tasks ---------------------------------------------------------------

begin
  ::Orhion.app
rescue
  ::Orihon.boot
end

::File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
  ::Dir.glob("#{path}/**/*.rb")
       .sort
       .each { require(_1) }
end
