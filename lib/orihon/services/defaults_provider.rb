# frozen_string_literal: true

require_relative '../services'

# Provides defaults config values.
class Orihon::Services::DefaultsProvider < Orihon::Services::BaseService
  # @return [Hash{Symbol => Object}]
  def call
    {
      tasks_debug: false,
      tasks_namespace: :orihon,
      # directories -----------------------------------------------------------
      notebook_dir: 'notebook',
      zim_export_dir: 'export',
      tmp_dir: 'tmp',
      # scss ------------------------------------------------------------------
      scss_process: true,
      scss_dir: 'resources/scss',
      scss_source_map_embed: true,
      scss_render_style: :expanded,
      # template --------------------------------------------------------------
      template_beautify: true,
    }
  end
end
