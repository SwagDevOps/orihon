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
    # @param default_task [String, Symbol, nil]
    # @param with_tasks [Boolean]
    #
    # @return [Orihon::App]
    def boot(config: nil, with_tasks: false, default_task: nil)
      App.boot(config: config, with_tasks: with_tasks).tap do
        if with_tasks and !default_task.to_s.empty? and self.const_defined?(:TaskApp)
          self.const_get(:TaskApp).new.then do |tasker|
            tasker.default(default_task)
          end
        end
      end
    end

    # @return [Orihon::App]
    def app
      App.instance
    end
  end
end
