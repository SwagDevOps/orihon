# frozen_string_literal: true

class Orihon
  autoload(:Pathname, 'pathname')

  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    $LOAD_PATH.unshift(File.dirname(path))

    {
      Actions: :actions,
      Config: :config,
      Configurable: :configurable,
      Services: :services,
    }.each { autoload(_1, "#{path}/#{_2}") }
  end

  class << self
    # @return [String]
    def bootstrap(with_tasks: false)
      path.join('bootstrap').tap do |bootstrap_dir|
        {
          boot: true,
          tasks: with_tasks,
        }
          .keep_if { _2 == true }
          .keys
          .map { bootstrap_dir.join("#{_1}.rb") }
          .each { ::Object.class_eval(_1.read, _1.to_s, 1) }
      end.to_s
    end

    # @param file [Pathname, String]
    #
    # @return [Config]
    def configure(file = nil)
      (file || Pathname.pwd.join('orihon.yml'))
        .to_s
        .then { |fp| Config.new(fp) }
    end

    # @return [Hash{Symbol => Class<Orihon::Services::BaseService>}]
    def services
      Services.all
    end

    protected

    # @return [Pathname]
    def path
      File.realpath(__FILE__)
          .gsub(/\.rb/, '')
          .then { |path| Pathname.new(path) }
    end
  end
end
