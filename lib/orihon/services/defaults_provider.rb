# frozen_string_literal: true

require_relative '../services'

# Provides defaults config values.
class Orihon::Services::DefaultsProvider < Orihon::Services::BaseService
  # @return [Hash{String => Object}]
  def call
    defaults.transform_keys(&:to_s).compact
  end

  protected

  # @return [Hash]
  def defaults
    {
      tasks_debug: false,
      zim_src_dir: 'notebook',
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
