# frozen_string_literal: true

require_relative '../orihon'

module Orihon::Actions
  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    {
      BaseAction: :base_action,
      BaseTemplateAction: :base_template_action,
      NotebookOpen: :notebook_open,
      NotebookExport: :notebook_export,
      NotebookPrepareStyle: :notebook_prepare_style,
      NotebookPrepareTemplate: :notebook_prepare_template,
    }.each { autoload(_1, "#{path}/#{_2}") }
  end
end
