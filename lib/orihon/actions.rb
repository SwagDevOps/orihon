# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Actions
  class << self
    include(::Orihon::Concerns::Registry)
  end

  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    {
      BaseAction: :base_action,
      BaseTemplateAction: :base_template_action,
      DependenciesInstall: :dependencies_install,
      NotebookOpen: :notebook_open,
      NotebookExport: :notebook_export,
      NotebookPrepareStyle: :notebook_prepare_style,
      NotebookPrepareTemplate: :notebook_prepare_template,
    }.then { register(_1, path: path) }.then do |h|
      self.define_singleton_method(:all) do
        h.map { [_1, self.const_get(_2)] }.to_h
      end
    end
  end
end
