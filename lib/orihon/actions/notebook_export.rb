# frozen_string_literal: true

require_relative '../actions'

class Orihon::Actions::NotebookExport < Orihon::Actions::BaseTemplateAction

  def call
    sh([
         'zim',
         '--export',
         '--format=html',
         '--verbose',
         '--overwrite',
         "--output=#{export_dir}",
         "--template=#{template}",
         src_dir
       ])
  end

  protected

  # @return [Pathname]
  def export_dir
    config.path(:zim_export_dir)
  end

  # @return [Pathname]
  def src_dir
    config.path(:notebook_dir)
  end
end
