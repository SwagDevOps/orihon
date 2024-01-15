# frozen_string_literal: true

# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

# noinspection RubyLiteralArrayInspection
Gem::Specification.new do |s|
  s.name        = "orihon"
  s.version     = "0.0.1"
  s.date        = "2024-01-08"
  s.summary     = "Build tasks on top of zim wiki"

  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/orhion"

  s.required_ruby_version = ">= 2.7.0"
  s.require_paths = ["lib"]
  s.files         = [
    "lib/orihon.rb",
    "lib/orihon/actions.rb",
    "lib/orihon/actions/base_action.rb",
    "lib/orihon/actions/base_template_action.rb",
    "lib/orihon/actions/notebook_export.rb",
    "lib/orihon/actions/notebook_open.rb",
    "lib/orihon/actions/notebook_prepare_style.rb",
    "lib/orihon/actions/notebook_prepare_template.rb",
    "lib/orihon/bootstrap/boot.rb",
    "lib/orihon/bootstrap/tasks.rb",
    "lib/orihon/bootstrap/tasks/vendorer.rb",
    "lib/orihon/bootstrap/tasks/zim.rb",
    "lib/orihon/concerns.rb",
    "lib/orihon/concerns/registry.rb",
    "lib/orihon/config.rb",
    "lib/orihon/configurable.rb",
    "lib/orihon/services.rb",
    "lib/orihon/services/base_service.rb",
    "lib/orihon/services/defaults_provider.rb",
    "lib/orihon/services/info.rb",
    "lib/orihon/services/structurizer.rb",
    "lib/orihon/services/template.rb",
    "lib/orihon/templates.rb",
    "lib/orihon/templates/base_dialect.rb",
    "lib/orihon/templates/dummy.rb",
    "lib/orihon/templates/html.rb",
    "lib/orihon/version.rb",
    "lib/orihon/version.yml",
  ]

  s.add_runtime_dependency("htmlbeautifier", ["~> 1.4"])
  s.add_runtime_dependency("inifile", ["~> 3.0"])
  s.add_runtime_dependency("liquid", ["~> 5.4"])
  s.add_runtime_dependency("rake", ["~> 13.0"])
  s.add_runtime_dependency("sassc", ["~> 2.4"])
  s.add_runtime_dependency("vendorer", ["~> 0.2"])
  s.add_runtime_dependency("wlang", ["~> 3.0"])
end

# Local Variables:
# mode: ruby
# End:
