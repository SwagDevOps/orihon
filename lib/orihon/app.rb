# frozen_string_literal: true

require_relative '../orihon'

class Orihon::App
  class << self
    # @return [Orihon::App]
    def boot(config: nil, with_tasks: false)
      self.new(config: config).tap do |app|
        # noinspection RubyGlobalVariableNamingConvention
        $ORIHON_INSTANCE = app

        app.__send__(:load_tasks) if with_tasks
      end
    end

    def instance
      # noinspection RubyGlobalVariableNamingConvention
      $ORIHON_INSTANCE.tap do |instance|
        return instance if instance

        raise RuntimeError, 'App must boot before use.'
      end
    end
  end

  protected

  # @return [Orihon::Config]
  attr_reader :config

  # @return [Hash{Symbol => Class<Orihon::Services::BaseService>}]
  def services
    ::Orihon::Services.all.transform_values { _1.new(config: config) }
  end

  # @return [Hash{Symbol => Class<Orihon::Actions::BaseAction>}]

  def actions
    ::Orihon::Actions.all.transform_values { _1.new(config: config) }
  end

  def initialize(config: nil)
    @config = self.configure(config).freeze
  end

  # Load (rake) tasks.
  #
  # @return [self]
  def load_tasks
    self.tap do
      self.basepath.join('tasks.rb').then do
        ::Object.class_eval(_1.read, _1.to_s, 1)
      end
    end
  end

  # @param file [Pathname, String, nil]
  #
  # @return [Config]
  def configure(file = nil)
    (file || Pathname.pwd.join('orihon.yml'))
      .to_s
      .then { |fp| ::Orihon::Config.new(fp) }
  end

  # @return [Pathname]
  def basepath
    File.realpath(__FILE__)
        .then { |path| Pathname.new(path).realpath }
        .then { |path| path.dirname }
  end
end
