# frozen_string_literal: true

class Orihon
  autoload(:Pathname, 'pathname')

  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    $LOAD_PATH.unshift(File.dirname(path))

    {
      Actions: :actions,
      App: :app,
      Concerns: :concerns,
      Config: :config,
      Configurable: :configurable,
      Services: :services,
      Templates: :templates,
    }.each { autoload(_1, "#{path}/#{_2}") }
  end

  class << self
    # @return [Orihon::App]
    def boot(config: nil, with_tasks: false)
      App.boot(config: config, with_tasks: with_tasks)
    end

    # @return [Orihon::App]
    def app
      App.instance
    end
  end
end
